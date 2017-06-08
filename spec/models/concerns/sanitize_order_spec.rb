RSpec.describe SanitizeOrder do

  describe '.sanitize_order_column' do
    it 'given a valid column, returns the correct result' do
      expect(TestModel.sanitize_order_column('name')).to eq 'name'
    end

    it 'given an unknown column, returns nil' do
      expect(TestModel.sanitize_order_column('foo')).to be_nil
    end
  end

  describe '.sanitize_table_name' do
    it 'given the current table name, returns the correct result' do
      expect(TestModel.sanitize_table_name('test_models')).to eq 'test_models'
    end

    it 'given an unknown table name, returns nil' do
      expect(TestModel.sanitize_table_name('foo')).to be_nil
    end
  end

  describe '.sanitize_order_direction' do
    it 'given "desc", returns DESC' do
      expect(TestModel.sanitize_order_direction('desc')).to eq 'DESC'
    end

    it 'given no direction, defaults to "ASC"' do
      expect(TestModel.sanitize_order_direction()).to eq 'ASC'
    end

    it 'given an unknown direction, returns "ASC"' do
      expect(TestModel.sanitize_order_direction('INVALID')).to eq 'ASC'
    end
  end

  describe '.sanitize_order_element' do
    it 'given a valid column and direction, returns a correct result' do
      expect(TestModel.sanitize_order_element(' number DESC'))
        .to eq 'test_models.number DESC'
    end

    it 'given an invalid column, returns empty string' do
      expect(TestModel.sanitize_order_element('invalid DESC')).to eq ''
    end

    it 'given valid table_name.column_name, returns a correct result' do
      expect(TestModel.sanitize_order_element('test_models.number DESC'))
        .to eq 'test_models.number DESC'
    end

    it 'given an unknown table name, returns nil' do
      expect(TestModel.sanitize_order_element('invalid.number DESC')).to be_nil
    end

    it 'given a blank table name, returns nil' do
      expect(TestModel.sanitize_order_element('.number DESC')).to be_nil
    end
  end

  describe '.whitelist_order_element' do
    whitelist = { 'param_number' => 'test_models.number' }

    it 'given a whitelist and included column, returns a translated column' do
      expect(TestModel.whitelist_order_element('param_number DESC', whitelist))
        .to eq 'test_models.number DESC'
    end

    it 'given a whitelist and unknown column, returns ''' do
      expect(TestModel.whitelist_order_element('unknown DESC', whitelist))
        .to eq ''
    end
  end

  describe '.sanitize_order_clause' do
    it 'given multiple columns and directions, return the correct result' do
      expect(TestModel.sanitize_order_clause('name, number DESC'))
        .to eq 'test_models.name ASC,test_models.number DESC'
    end

    it 'given a whitelist and included column, returns the correct result' do
      whitelist = { 'param_number' => 'test_models.number' }

      expect(TestModel.sanitize_order_clause('param_number DESC, name ASC', whitelist))
        .to eq 'test_models.number DESC'
    end

    it 'given an empty string, returns empty string' do
      expect(TestModel.sanitize_order_clause('')).to eq ''
    end

    it 'given a blank string, returns empty string' do
      expect(TestModel.sanitize_order_clause(' ')).to eq ''
    end
  end

  # thanks http://pivotallabs.com/testing-active-record-scopes/
  context 'with TestModel' do

    before :all do
      @a3 = TestModel.create!(name: 'abc', number: 3)
      @b2 = TestModel.create!(name: 'bcd', number: 2)
      @c1 = TestModel.create!(name: 'cde', number: 1)
    end

    after :all do
      @a3.destroy; @b2.destroy; @c1.destroy
    end

    it 'give "name", by default orders by name ascending' do
      expect(TestModel.sanitize_order('name')).to eq([@a3, @b2, @c1])
    end

    it 'given "name asc" orders by name ascending' do
      expect(TestModel.sanitize_order('name')).to eq([@a3, @b2, @c1])
    end

    it 'given "name desc" orders by name descending' do
      expect(TestModel.sanitize_order('name desc')).to eq([@c1, @b2, @a3])
    end

    it 'given "number asc", orders by number ascending' do
      expect(TestModel.sanitize_order('number asc')).to eq([@c1, @b2, @a3])
    end

    context 'with a duplicate name' do
      before :all do
        @a2 = TestModel.create!(name: @a3.name, number: 2)
      end

      after :all do
        @a2.destroy
      end

      it 'given "number, name", produces a correct result' do
        expect(TestModel.sanitize_order('number, name')).to eq([@c1, @a2, @b2, @a3])
      end

      it 'given "name asc, number asc", produces a correct result' do
        expect(TestModel.sanitize_order('name, number')).to eq([@a2, @a3, @b2, @c1])
      end
    end

    context 'the default scope' do
      [nil, '', 'wrong_column', 'name; drop table test_models'].each do |param|
        it "given #{param.inspect}, returns the default ordering" do
          expect(TestModel.sanitize_order(param)).to eq [@a3, @b2, @c1]
        end
      end
    end
  end
end
