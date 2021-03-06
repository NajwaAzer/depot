
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?, "Product is valid"
		assert product.errors[:title].any?, "Product title has no errors"
		assert product.errors[:description].any?, "Product description has no errors"
		assert product.errors[:price].any?, "Product price has no errors"
		assert product.errors[:image_url].any?, "Image URL has no errors"
	end

	test "product price must be positive" do
		product = Product.new(	title: "My Book Title",
								description: "yyy",
								image_url: "zzz.jpg")
		
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
		
		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
		
		product.price = 1
		assert product.valid?
	end

	def new_product(image_url)
		Product.new(title: "My Book Title",
					description: "yyy",
					price: 1,
					image_url: image_url)
	end

	test "image url filetype must be valid" do
		ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
		bad = %w{ fred.doc fred.gif/more fred.gif.more }
		
		ok.each do |name|
			assert new_product(name).valid?, "#{name} shouldn't be invalid"
		end
		
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end

	test "product is not valid without a unique title" do
		product = Product.new(	title: products(:ruby).title,
								description: "yyy",
								price: 1,
								image_url: "fred.gif")
		assert product.invalid?
		assert_equal ["has already been taken"], product.errors[:title]
	end

	test "product title must be at least ten characters" do
		product = Product.new(	description: "yyy",
								image_url: "zzz.jpg",
								price: 10 )
		
		product.title = "Too short"
		assert product.invalid?
		assert_equal ["is too short (minimum is 10 characters)"], product.errors[:title]
		
		product.title = "Characters"
		assert product.valid?
	end

end
