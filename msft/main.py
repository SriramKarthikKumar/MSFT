
# MSFT Sample Classes and Data Persistence
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://admin:admin@localhost/Test'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


class Stock(db.Model):
    company_id = db.Column(db.Integer, primary_key=True)
    company_name = db.Column(db.String(50), nullable=False)
    currency = db.Column(db.String(3), nullable=False)
    country = db.Column(db.String(50), nullable=False)

    def __init__(self, company_id, company_name, currency, country):
        self.company_id = company_id
        self.company_name = company_name
        self.currency = currency
        self.country = country


@app.route('/new_stocks', methods=['POST'])
def create_stock():
    data = request.get_json()
    new_stock = Stock(company_id=data['company_id'], company_name=data['company_name'], currency=data['currency'], country=data['country'])
    db.session.add(new_stock)
    db.session.commit()
    return jsonify({'message': 'Stock created successfully.'}), 201


@app.route('/stocks', methods=['GET'])
def get_books():
    stocks = Stock.query.all()
    result = []
    for stock in stocks:
        stock_data = {'id': stock.company_id,
                      'company_name': stock.company_name,
                      'currency': stock.currency,
                      'country': stock.country
                      }
        result.append(stock_data)
    return jsonify(result), 200


if __name__ == '__main__':
    app.run(debug=True)
