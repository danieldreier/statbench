require 'spec_helper'

class TestStatistic
  include TestStatisticHelper
  describe TestStatistic do 

    ### INSTANTIATION WITH ACTUAL STATISTIC VALUE UNKNOWN ###

    it 'instantiates with correct z-value' do       # This will pas
      z = TestStatisticHelper::initialize_with({ :distribution => 'z',
                              :alpha => 0.025 })
      z.abs.should be_within(0.0005).of(1.96)
    end

    it 'instantiates with correct t-value' do       # This will pass
      t = TestStatisticHelper::initialize_with({ :distribution => 't',
                              :alpha => 0.05,
                              :degrees_of_freedom => 18 })
      t.abs.should be_within(0.0005).of(1.734)
    end

    it 'instantiates with correct chi-square value' do  # This will pass
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'right',
                                 :degrees_of_freedom => 16 })
      chi2.should be_within(0.0005).of(26.296)
    end

    it 'instantiates with correct F-value' do   # This will pass
      f = TestStatisticHelper::initialize_with({ :distribution => 'f',
                              :p => 0.05,
                              :tail => 'right',
                              :degrees_of_freedom_1 => 17,
                              :degrees_of_freedom_2 => 23 })
      f.should be_within(0.0005).of(2.091)
    end

    ### INSTANTIATION WITH STATISTIC VALUE KNOWN ###

    it 'instantiates with correct alpha given value, distribution (z)' do   # This will pass
      z = TestStatisticHelper::initialize_with({ :distribution => 'z',
                              :value => 1.96 })
      z.p.should be_within(0.0005).of(0.025)
    end

    it 'instantiates with correct alpha given value, distribution, nu (t)' do 
      t = TestStatisticHelper::initialize_with({ :distribution => 't',
                                                 :value => 1.8595,
                                                 :degrees_of_freedom => 8 })
      t.p.should be_within(0.001).of(0.05)
    end

    it 'instantiates with correct nu given value, distribution, alpha (t)' do 
      t = TestStatisticHelper::initialize_with({ :distribution => 't',
                                                 :value => -1.8595,
                                                 :p => 0.05 })
      t.nu.should == 8
    end

    it 'instantiates with correct distribution given value, alpha, nu (t)' do 
      t = TestStatisticHelper::initialize_with({ :value => 2.093,
                              :alpha => 0.025,
                              :degrees_of_freedom => 19 })
      t.distribution.should be("t")
    end

    it 'instantiates with correct nu given value, alpha, distribution (chi2)' do 
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :value => '17.708'})
      chi2.degrees_of_freedom.should be(29)
    end

    it 'instantiates with correct alpha given value, distribution, nu, tail (chi2)' do 
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                                    :value =>15.5073,
                                                    :degrees_of_freedom =>8,
                                                    :tail => 'right' })
      chi2.p.should be_within(0.001).of(0.05)
    end


    ### GENERAL BEHAVIOR ###

    it 'can be used in calculations like a float' do        # This will pass
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                 :degrees_of_freedom => 23,
                                 :p => 0.05,
                                 :tail => 'right' 
                              })
      (chi2 * 1.86).should be_instance_of(Numeric)
    end

    it 'accepts the names :alpha and :p for probability of Type I error' do # This will pass
      z1 = TestStatisticHelper::initialize_with({ :distribution => 'z',
                               :p => 0.05 })
      z2 = TestStatisticHelper::initialize_with({ :distribution => 'z',
                               :alpha => 0.05 })
      z1.should == z2
    end

    ### ACCESSING ATTRIBUTES ###

    it 'gives a hash of information about itself when queried' do # This will pass
      z = TestStatisticHelper::initialize_with({ :distribution => "z",
                              :p => 0.025 })
      z.attributes.should be_instance_of(Hash)
    end

    it 'displays only attributes relevant to the particular distribution' do # This will pass
      t = TestStatisticHelper::initialize_with({ :distribution => "t",
                              :degrees_of_freedom => 20,
                              :p => 0.05,
                              :tail => 'right'
                           })
      t.attributes.should_not have_key(:tail)
    end

    it 'returns its distribution' do     # This will pass
      z = TestStatisticHelper::initialize_with({ :distribution => 'z',
                              :alpha => 0.025 })
      z.distribution.should be('z')
    end

    it 'returns its degrees of freedom (except z and f)' do  # This will pass
      t = TestStatisticHelper::initialize_with({ :distribution => 't',
                             :p => 0.05,
                             :degrees_of_freedom => 19 })
      t.degrees_of_freedom.should be(19)
    end

    it 'returns its degrees_of_freedom (f)' do
      f = TestStatisticHelper::initialize_with({ :distribution => 'f',    # This will pass
                                                 :p => 0.05,
                                                 :tail => 'right',
                                                 :degrees_of_freedom_1 => 8,
                                                 :degrees_of_freedom_2 => 24 })
      f.nu1.should be(8)
      f.nu2.should be(24)
    end

    it 'returns nil when z-statistic asked for degrees of freedom' do 
      z = TestStatisticHelper::initialize_with({ :distribution => 'z',
                              :p => 0.025 })
      z.nu.should be(nil)
    end

    it 'returns its p-value when queried for p value' do         # This will pass
      z = TestStatisticHelper::initialize_with({ :distribution => 'z',
                              :alpha => 0.05 })
      z.p_value.should be(0.05)
    end

    it 'returns its tail when queried' do             # This will pass
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :degrees_of_freedom => 20 })
      chi2.tail.should be('left')
    end

    ### MUTABILITY ###

    it 'changes its value when attributes changed' do   # This will pass
      chi2 = TestStatisticHelper::initialize_with({ :distribution => 'chi2',
                                 :alpha => 0.05,
                                 :tail => 'left',
                                 :degrees_of_freedom => 21
                              })
      chi2.should be_within(0.00005).of(11.5913)
      chi2 = TestStatisticHelper::edit_attribute(chi2,'alpha',0.1)
      chi2.should be_within(0.00005).of(13.2395)
    end

    it 'changes its value when degrees of freedom change' do  # This will pass
      t = TestStatisticHelper::initialize_with({ :distribution => 't',
                              :alpha => 0.05,
                              :degrees_of_freedom => 15 })
      t.abs.should be_within(0.0005).of(1.753)
      t = TestStatisticHelper::edit_attribute(t,'nu',20)
      t.abs.should be_within(0.0005).of(1.725)
    end

    ### CAN BE INSTANTIATED WITH A MINIMUM NUMBER OF PARAMETERS ###

    ### Note: These functionalities have been put on the back burner due to
    ###       limitations in the Distribution gem

    ### Z ###
    it 'instantiates a z-statistic using only alpha and value' do 
      z = TestStatisticHelper::initialize_with({ :value => 1.96,
                              :alpha => 0.025 })
      z.distribution.should be('z')
    end

    it 'instantiates a z-statistic using only value and distribution' do
      z = TestStatisticHelper::initialize_with({ :value => 1.96,
                              :distribution => 'z' })
      z.p_value.should be_within(0.005).of(0.05)
    end

    ### T ###
    it 'instantiates a t-statistic using only alpha, value, & distribution' do 
      t = TestStatisticHelper::initialize_with( { :distribution => 't',
                               :value => 1.691,
                               :alpha => 0.05 })
      t.degrees_of_freedom.should be(34)
    end

    it 'instantiates a t-statistic using value, distribution, and nu' do 
      t = TestStatisticHelper::initialize_with( { :distribution => 't',
                               :value => 1.691,
                               :degrees_of_freedom => 34 })
      t.alpha.should be_within(0.001).of(0.05)
    end

    it 'instantiates a t-statistic using alpha, value, and nu' do 
      t = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 34,
                              :value => 1.691,
                              :alpha => 0.05 })
      t.distribution.should be('t')
    end

    ### CHI-SQUARE ###

    # Coming soon!

  end
end