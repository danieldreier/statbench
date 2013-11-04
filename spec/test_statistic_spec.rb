require 'spec_helper'

class TestStatistic
  describe TestStatistic do 

    ### INSTANTIATION WITH ACTUAL STATISTIC VALUE UNKNOWN ###

    it 'instantiates with correct z-value' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :alpha => 0.025 })
      z.should be_within(0.005).of(1.96)
    end

    it 'instantiates with correct t-value' do
      t = TestStatistic.new({ :distribution => 't',
                              :alpha => 0.05,
                              :degrees_of_freedom => 18 })
      t.should be_within(0.0005).of(1.734)
    end

    it 'instantiates with correct chi-square value' do
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'right',
                                 :degrees_of_freedom => 16 })
      chi2.should be_within(0.0005).of(26.296)
    end

    it 'instantiates with correct F-value' do
      f = TestStatistic.new({ :distribution => 'f',
                              :p => 0.05,
                              :tail => 'right',
                              :degrees_of_freedom_1 => 17,
                              :degrees_of_freedom_2 => 23 })
      f.should be_within(0.0005).of(2.091)
    end

    ### INSTANTIATION WITH STATISTIC VALUE KNOWN ###

    it 'instantiates with correct alpha given value, distribution' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :value => 1.96 })
      z.alpha.should be_within(0.0005).of(0.025)
    end

    it 'instantiates with correct distribution given value, alpha, nu' do 
      t = TestStatistic.new({ :value => 2.093,
                              :alpha => 0.025,
                              :degrees_of_freedom => 19 })
      t.distribution.should be("Student's t")
    end

    it 'instantiates with correct nu given value, alpha, distribution' do 
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :value => '17.708'})
      chi2.degrees_of_freedom.should be(29)
    end

    ### GENERAL BEHAVIOR ###

    it 'can be used in calculations like any other float' do 
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :degrees_of_freedom => 23,
                                 :p => 0.05,
                                 :tail => 'right' 
                              })
      (chi2 * 1.86).should be_within(0.0005).of(65.383)
    end

    it 'accepts the names :alpha and :p for probability of Type I error' do 
      z1 = TestStatistic.new({ :distribution => 'z',
                               :p => 0.05 })
      z2 = TestStatistic.new({ :distribution => 'z',
                               :alpha => 0.05 })
      z1.should == z2
    end

    ### ACCESSING ATTRIBUTES ###

    it 'gives a hash of information about itself when queried (z-dist)' do 
      z = TestStatistic.new({ :distribution => "z",
                              :p => 0.025 })
      z.info[:value].should be_within(0.0005).of(1.96)
      z.info[:p].should be(0.025)
      z.info[:distribution].should be('z')
    end

    it 'gives a hash of information about itself when queried (t-dist)' do 
      t = TestStatistic.new({ :distribution => "t",
                              :degrees_of_freedom => 20,
                              :p => 0.05
                           })
      t.info[:value].should be_within(0.0005).of(1.729)
      t.info[:p].should be(0.05)
      t.info[:degrees_of_freedom].should be(20)
      t.info[:distribution].should be("Student's t")
    end

    it 'gives a hash of information about itself when queried (chi-square)' do 
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :degrees_of_freedom => 20,
                                 :p => 0.05,
                                 :tail => 'left' })
      chi2.info[:value].should be_within(0.0005).of(10.851)
      chi2.info[:distribution].should be('chi-square')
      chi2.info[:degrees_of_freedom].should be(20)
      chi2.info[:p].should be(0.05)
      chi2.info[:tail].should be('left')
    end

    it 'gives a hash of information about itself when queried (F-dist)' do 
      f = TestStatistic.new({ :distribution => "f",
                              :p => 0.05,
                              :tail => 'right',
                              :degrees_of_freedom_1 => 8,
                              :degrees_of_freedom_2 => 24 })
      f.info[:value].should be_within(0.0005).of(2.355)
      f.info[:distribution].should be('F')
      f.info[:p].should be(0.05)
      f.info[:tail].should be('right')
      f.info[:degrees_of_freedom_1].should be(8)
      f.info[:degrees_of_freedom_2].should be(24)
    end

    it 'returns its distribution type when queried' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :alpha => 0.025 })
      z.distribution.should be('z')
    end

    it 'returns its degrees of freedom when queried (other than z and F)' do
      t = TestStatistic.new({ :distribution => 't',
                             :p => 0.05,
                             :degrees_of_freedom => 19 })
      t.degrees_of_freedom.should be(19)
    end

    it 'returns its degrees of freedom when queried (F)' do
      f = TestStatistic.new({ :distribution => "f",
                              :p => 0.05,
                              :tail => 'right',
                              :degrees_of_freedom_1 => 8,
                              :degrees_of_freedom_2 => 24 })
      f.degrees_of_freedom.should == [8, 24]
    end

    it 'returns nil when z-statistic asked for degrees of freedom' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :p => 0.025 })
      z.degrees_of_freedom.should be(nil)
    end

    it 'returns its p-value when queried for p value' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :alpha => 0.05 })
      z.p_value.should be(0.05)
    end

    it 'returns its tail when queried (chi-square)' do
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :degrees_of_freedom => 20 })
      chi2.tail.should be('left')
    end

    it 'returns its tail when queried (F)' do
      f = TestStatistic.new({ :distribution => 'f',
                              :alpha => 0.05,
                              :tail => 'both',
                              :degrees_of_freedom_1 => 5,
                              :degrees_of_freedom_2 => 17
                           })
      f.tail.should be('both')
    end

    ### MUTABILITY ###

    it 'changes its value when alpha changed' do 
      chi2 = TestStatistic.new({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :degrees_of_freedom => 21
                              })
      chi2.should be_within(0.0005).of(10.591)
      chi2[:alpha] = 0.1
      chi2.should be_within(0.0005).of(13.240)
    end

    it 'changes its value when degrees of freedom change' do 
      t = TestStatistic.new({ :distribution => 't',
                              :alpha => 0.05,
                              :degrees_of_freedom => 15 })
      t.should be_within(0.0005).of(1.753)
      t.degrees_of_freedom = 20
      t.should be_within(0.0005).of(1.725)
    end

    it 'returns an error if value changed without changing attributes' do 
      z = TestStatistic.new({ :distribution => 'z',
                              :alpha => 0.025 })
      z.should be_within(0.004).of(1.96)
      # And I'm not completely sure how to require an error
    end

    ### CAN BE INSTANTIATED WITH A MINIMUM NUMBER OF PARAMETERS ###

    ### Z ###
    it 'instantiates a z-statistic using only alpha and value' do 
      z = TestStatistic.new({ :value => 1.96,
                              :alpha => 0.025 })
      z.type.should be('z')
    end

    it 'instantiates a z-statistic using only value and distribution' do
      z = TestStatistic.new({ :value => 1.96,
                              :distribution => 'z' })
      z.p_value.should be_within(0.005).of(0.05)
    end

    ### T ###
    it 'instantiates a t-statistic using only alpha, value, & distribution' do 
      t = TestStatistic.new( { :distribution => 't',
                               :value => 1.691,
                               :alpha => 0.05 })
      t.degrees_of_freedom.should be(34)
    end

    it 'instantiates a t-statistic using value, distribution, and nu' do 
      t = TestStatistic.new( { :distribution => 't',
                               :value => 1.691,
                               :degrees_of_freedom => 34 })
      t.alpha.should be_within(0.001).of(0.05)
    end

    it 'instantiates a t-statistic using alpha, value, and nu' do 
      t = TestStatistic.new({ :degrees_of_freedom => 34,
                              :value => 1.691,
                              :alpha => 0.05 })
      t.distribution.should be('t')
    end

    ### CHI-SQUARE ###

    # Coming soon!

  end
end