require 'master_forest'
include MasterForest

describe MasterForest do
  context 'parsing' do
    let(:s)    { Term.new 's'     }
    let(:k)    { Term.new 'k'     }
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

    describe '#==' do
      it 'is reflexive' do
        (Term.new '``skk').should == (Term.new '``skk')
      end
      it 'distinct normal terms are not equal' do
        skk.should_not == s_kk
      end
    end

    context 'explicit tree building' do
      it 'generates to_s as needed' do
        (Term.new nil, s, k).to_s.should == '`sk'
      end
      it 'string overrides explicit children' do
        (Term.new 'i', s, k).to_s.should == 'i'
      end
      it 'refuses to create an entirely blank node' do
        expect { Term.new nil }.to raise_error
      end
    end
  end

  describe '#valid?' do
    let (:leaf) { Term.new 'k'       }
    let (:good) { Term.new '``ii`ii' }
    let (:bad)  { Term.new '`iX'     }
    let (:long) { Term.new '`iii'    }

    it 'says valid terms are valid' do
      leaf.should be_valid
      good.should be_valid
    end
    it 'does not allow symbols other than `,s,k,i' do
      bad.should_not be_valid
    end
    it 'does not allow extraneous characters at end' do
      long.should_not be_valid
    end
  end

  describe '#reduce' do
    let(:s)    { Term.new 's'       }
    let(:ii)   { Term.new '`ii'     }
    let(:ki)   { Term.new '`ki'     }
    let(:si)   { Term.new '`si'     }
    let(:kis)  { Term.new '``kis'   }
    let(:siks) { Term.new '```siks' }

    it 'does not alter a leaf' do
      s.reduce.to_s.should == 's'
    end

    it 'does not alter k or s with too little depth' do
      ki.reduce.should == ki
      si.reduce.should == si
    end

    it 'drops i combinator' do
      ii.reduce.to_s.should == 'i'
    end

    it 'applies k combinator' do
      kis.reduce.to_s.should == 'i'
    end

    it 'applies s combinator' do
      reduced = siks.reduce
      reduced.to_s.should == '``ik`is'
      reduced.l.to_s.should == '`ik'
      reduced.r.to_s.should == '`is'
    end
  end

  describe '#normal' do
    let (:leaf) { Term.new 'i'   }
    let (:app)  { Term.new '`ki' }
    let (:ii)   { Term.new '`ii' }
    let (:active_l) { Term.new '``iik'}
    let (:active_r) { Term.new '`k`ii'}

    context 'given a leaf' do
      it 'always says normal' do
        leaf.should be_normal
      end
    end
    context 'given an application' do
      it 'is sometimes normal' do
        app.should be_normal
      end
      it 'i application is never normal' do
        ii.should_not be_normal
      end
      it 'detects active subterms' do
        active_l.should_not be_normal
        active_r.should_not be_normal
      end
    end
  end
end
