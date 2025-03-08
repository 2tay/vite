// OrderItem model for order-menu item relationship
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const OrderItem = sequelize.define('OrderItem', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    order_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Orders',
        key: 'id'
      }
    },
    menu_item_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'MenuItems',
        key: 'id'
      }
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1,
      validate: {
        isInt: true,
        min: 1
      }
    },
    unit_price: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: {
        isDecimal: true,
        min: 0
      }
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true
    }
  }, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
    hooks: {
      // Before creating an order item, get the current price of the menu item
      beforeCreate: async (orderItem, options) => {
        if (!orderItem.unit_price) {
          const MenuItem = sequelize.models.MenuItem;
          const menuItem = await MenuItem.findByPk(orderItem.menu_item_id);
          
          if (menuItem) {
            orderItem.unit_price = menuItem.price;
          }
        }
      },
      // After creating or destroying order items, update the order total
      afterCreate: async (orderItem, options) => {
        await updateOrderTotal(orderItem.order_id, options);
      },
      afterDestroy: async (orderItem, options) => {
        await updateOrderTotal(orderItem.order_id, options);
      }
    }
  });

  // Helper function to update order total
  async function updateOrderTotal(orderId, options) {
    const transaction = options.transaction;
    
    const Order = sequelize.models.Order;
    const OrderItem = sequelize.models.OrderItem;
    
    // Calculate total from all order items
    const items = await OrderItem.findAll({
      where: { order_id: orderId },
      transaction
    });
    
    const total = items.reduce((sum, item) => {
      return sum + (parseFloat(item.unit_price) * item.quantity);
    }, 0);
    
    // Update the order with the new total
    await Order.update(
      { total_amount: total },
      { 
        where: { id: orderId },
        transaction
      }
    );
  }

  // No need for associate method as the associations are defined in Order and MenuItem models

  return OrderItem;
};