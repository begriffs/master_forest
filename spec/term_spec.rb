require 'master_forest'
include MasterForest

describe MasterForest do
  let(:s)    { Term.new 's'     }
  let(:sk)   { Term.new '`sk'   }
  let(:skk)  { Term.new '``skk' }
  let(:s_kk) { Term.new '`s`kk' }
  let(:bad)  { Term.new '``s'   }

  context 'leaf node' do
    it 'parses' do
      s.to_s.should == 's'
    end

    it 'is a leaf' do
      s.leaf?.should be_true
    end

    it 'has no children' do
      s.l.should be_nil
      s.r.should be_nil
    end
  end

  context 'application' do
    it 'parses' do
      sk.to_s.should == '`sk'
      sk.l.to_s.should == 's'
      sk.r.to_s.should == 'k'
    end

    it 'parses deeper as needed on left' do
      skk.l.to_s.should == '`sk'
      skk.r.to_s.should == 'k'
      skk.l.l.to_s.should == 's'
    end

    it 'parses deeper as needed on right' do
      s_kk.l.to_s.should == 's'
      s_kk.r.to_s.should == '`kk'
      s_kk.r.l.to_s.should == 'k'
    end

    it 'is not a leaf' do
      sk.leaf?.should be_false
    end
  end

  context 'invalid' do
    it 'fails to parse' do
      expect { bad.l }.to raise_error
    end
  end
end
