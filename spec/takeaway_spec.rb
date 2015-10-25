require 'takeaway'

describe Takeaway do
  subject(:takeaway) { Takeaway.new(menu) }
  let(:menu) { { menuitem1: 1, menuitem2: 1.50 } }

  describe '#show_menu' do
    it 'shows a list of menu items' do
      expect(takeaway.show_menu).to eq takeaway.menu
    end
  end

  describe '#order' do
    context 'first order' do
      it 'stores name and quantity of dish in basket' do
        takeaway.order( :menuitem1,  2)
        expect(takeaway.basket).to include [:menuitem1, 2]
      end
    end
    context 'additional orders' do
      it 'stores name and quantity of dish in basket' do
        takeaway.order( :menuitem1,  2)
        takeaway.order( :menuitem2,  5)
        expect(takeaway.basket).to include [:menuitem2, 5]
      end
    end
  end

  describe '#complete_order' do
    context 'when total given by user corresponds to calculated total' do
      it 'sends a confirmation text message' do
        takeaway.order :menuitem1, 2
        expect(takeaway).to receive(:send_text).with('Thank you for your order: £2')
        takeaway.complete_order(2)
      end
    end
    context 'total given by user does not correspond to calculated total' do
      it 'raises an error' do
        takeaway.order( :menuitem2,  5)
        expect {takeaway.complete_order(7)}.to raise_error 'Wrong total'
      end
    end
  end

  describe '#basket_summary' do
    it 'shows the ordered items and the total' do
      takeaway.order(order: { menuitem1: 2 , menuitem2: 5}, total: 9.50)
      expect(takeaway.basket_summary).to eq takeaway.basket
    end
  end
end
