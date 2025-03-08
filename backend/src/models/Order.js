// Order model for customer orders
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Order = sequelize.define('Order', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    table_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'Tables',
        key: 'id'
      }
    },
    status: {
      type: DataTypes.ENUM('received', 'preparing', 'ready', 'delivered', 'cancelled'),
      defaultValue: 'received'
    },
    total_amount: {
      type: DataTypes.DECIMAL(10, 2),
      defaultValue: 0,
      validate: {
        isDecimal: true,
        min: 0
      }
    },
    special_instructions: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    created_by: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'Users',
        key: 'id'
      }
    }
  }, {
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    hooks: {
      // Calculate total amount before update
      beforeUpdate: async (order) => {
        if (order.changed('status') && order.status === 'delivered') {
          // You might want to update some statistics here
        }
      }
    }
  });

  // Define associations
  Order.associate = (models) => {
    Order.belongsTo(models.Table, {
      foreignKey: 'table_id',
      as: 'table'
    });

    Order.belongsTo(models.User, {
      foreignKey: 'created_by',
      as: 'creator'
    });

    Order.belongsToMany(models.MenuItem, {
      through: models.OrderItem,
      foreignKey: 'order_id',
      otherKey: 'menu_item_id',
      as: 'menuItems'
    });
  };

  return Order;
};