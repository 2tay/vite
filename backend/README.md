# Restaurant Management System Backend

This is the backend service for the Restaurant Management System, providing API endpoints for the restaurant staff mobile application and customer web application.

## Technologies Used

- Node.js with Express
- MySQL database with Sequelize ORM
- JWT authentication
- Socket.io for real-time updates

## Prerequisites

- Node.js (v14 or higher)
- MySQL server
- npm or yarn package manager

## Setup Instructions

1. Clone the repository:
```bash
git clone <repository-url>
cd vite/backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file in the root directory with the following content:
```
PORT=5000
DB_HOST=localhost
DB_USER=vite_admin
DB_PASS=1234567890
DB_NAME=vite
JWT_SECRET=18f5ee7d73146c29ccd498889586f0071d8d232b320c93b275755ff43fd95837
```

4. Create a MySQL database and user:
```sql
CREATE DATABASE vite;
CREATE USER 'vite_admin'@'localhost' IDENTIFIED BY '1234567890';
GRANT ALL PRIVILEGES ON vite.* TO 'vite_admin'@'localhost';
FLUSH PRIVILEGES;
```

5. Create an uploads directory if it doesn't exist:
```bash
mkdir -p uploads
touch uploads/.gitkeep
```

6. Start the server:
```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

The server will start on port 5000 (or the port specified in your .env file).

## API Endpoints

### Authentication
- POST /api/auth/login - Staff login
- POST /api/auth/logout - Staff logout

### Menu Management
- GET /api/menu - Get all menu items
- GET /api/menu/:id - Get single menu item
- POST /api/menu - Add new menu item
- PUT /api/menu/:id - Update menu item
- DELETE /api/menu/:id - Delete menu item

### Category Management
- GET /api/categories - Get all categories
- POST /api/categories - Add new category
- PUT /api/categories/:id - Update category
- DELETE /api/categories/:id - Delete category

### Order Management
- GET /api/orders - Get all orders
- GET /api/orders/:id - Get single order
- POST /api/orders - Create new order
- PUT /api/orders/:id - Update order status
- GET /api/orders/table/:tableId - Get orders for a table

### Table Management
- GET /api/tables - Get all tables
- GET /api/tables/:id - Get single table
- POST /api/tables - Add new table
- PUT /api/tables/:id - Update table status
- GET /api/tables/:id/qr - Get QR code for a table

## License

This project is licensed under the MIT License.