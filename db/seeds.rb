Category.create(name: 'Electronics', keyword: 'Laptop')
Category.create(name: 'Software', keyword: 'New')
Category.create(name: 'Appliances', keyword: 'Refrigerator')
Category.create(name: 'Apparel', keyword: 'Men')
Category.create(name: 'Books', keyword: 'Books')
User.create(email: 'admin@zigexn.vn', password: 'zigexn123',
            role: User.role_users[:admin])
