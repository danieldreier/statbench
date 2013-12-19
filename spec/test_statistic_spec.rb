require_relative 'spec_helper'

class TestStatistic
  include TestStatisticHelper

  ACCEPTABLE_ERROR = 0.0005

  describe TestStatistic do
    describe 'general characteristics' do 
      it 'can be used in calculations like a float' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :p            => 0.025 })
        expect(z * 1.5).to be_instance_of(Float)
      end

      it 'can be initialized with :p, :alpha, or :significance_level as probability of Type I error' do 
        z1 = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                    :p            => 0.025 })
        z2 = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                    :alpha        => 0.025 })
        z1.should eql(z2)
      end

      it 'can use absolute value method without reverting to plain old float' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                    :p            => 0.025 })
        absolute_value = z.abs 
        absolute_value.should be_instance_of(TestStatistic)
      end
    end

    describe 'attribute reader' do 
      it 'gives a hash of its own attributes' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :alpha        => 0.025 })
        z.attributes.should be_instance_of(Hash)
      end

      it 'only displays attributes relevant to its distribution' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 20,
                                                   :alpha              => 0.05,
                                                   :tail               => 'right' })
        t.attributes.should_not have_key(:tail)
      end

      it 'returns its distribution' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :alpha        => 0.05 })
        z.distribution.should be(:z)
      end

      it 'returns its degrees of freedom' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 25,
                                                   :alpha              => 0.025 })
        t.degrees_of_freedom.should be(25)
      end

      it 'responds to queries for #p, #alpha, or #p_value' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :p            => 0.05 })
        z.p.should equal(z.alpha)
        z.p.should equal(z.p_value)
      end

      it 'returns its tail' do 
        chi2 = TestStatisticHelper::initialize_with({ :distribution       => :chi2,
                                                      :tail               => 'right',
                                                      :degrees_of_freedom => 16,
                                                      :p                  => 0.05 })
        chi2.tail.should equal('right')
      end
    end

    describe 'z-statistic' do 
      describe 'instantiation' do 
        context 'with actual statistic value unknown' do 
          it 'instantiates with the correct z-value' do 
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :alpha        => 0.025 })
            z.abs.should be_within(ACCEPTABLE_ERROR).of(1.96)
          end
        end

        context 'with actual statistic value unknown' do 
          it 'instantiates with the correct alpha given value' do 
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :value        => 1.96 })
            z.alpha.should be_within(ACCEPTABLE_ERROR).of(1.96)
          end

          it 'instantiates with z-distribution given alpha and value' do 
            pending "additional Distribution functionality"
            z = TestStatisticHelper::initialize_with({ :value => 1.96,
                                                       :alpha => 0.025 })
            z.distribution.should_be(:z)
          end

          it 'instantiates with alpha given distribution and value' do 
            pending "additional Distribution functionality"
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :value        => 1.96 })
            z.alpha.should be_within(ACCEPTABLE_ERROR).of(0.025)
          end
        end
      end

      describe "attributes" do 
        it 'returns nil when queried for degrees of freedom' do 
          z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                     :alpha        => 0.025 })
          z.degrees_of_freedom.should_be(nil)
        end
      end
    end

    describe "t-statistic" do 
      describe "instantiation" do 
        context 'with statistic value unknown' do 
          it 'instantiates with the correct value' do 
            t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                       :alpha              => 0.05,
                                                       :degrees_of_freedom => 18 })
            t.should be_within(ACCEPTABLE_ERROR).of(1.734)
          end
        end

        context 'with statistic value known' do 
          it 'instantiates with correct alpha' do 
            t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                       :degrees_of_freedom => 8,
                                                       :value              => 1.8595 })
            t.alpha.should be_within(ACCEPTABLE_ERROR).of(0.05)
          end

          it 'instantiates with correct nu' do 
            t = TestStatisticHelper::initialize_with({ :distribution => :t,
                                                       :alpha        => 0.05,
                                                       :value        => -1.8595 })
            t.nu.should == 8
          end

          it 'instantiates with correct distribution' do 
            t = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 19,
                                                       :value              => 2.093,
                                                       :p                  => 0.025 })
            t.distribution.should == :t 
          end
        end
      end
    end

    describe 'chi-square statistic' do 
      describe 'instantiation' do 
        context 'with statistic value known' do 
          it 'instantiates with correct value' do 
            chi2 = TestStatisticHelper::initialize_with({ :distribution       => :chi2,
                                                          :tail               => 'right',
                                                          :degrees_of_freedom => 16,
                                                          :alpha              => 0.05 })
            chi2.should be_within(ACCEPTABLE_ERROR).of(26.296)
          end
        end

        context 'with statistic value unknown' do 
          it 'instantiates with correct nu' do 
            chi2 = TestStatisticHelper::initialize_with({ :distribution => :chi2,
                                                          :tail         => 'left',
                                                          :value        => 17.708,
                                                          :p            => 0.05 })
            chi2.degrees_of_freedom.should == 29
          end

          it 'instantiates with correct alpha' do 
            chi2 = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 8,
                                                          :distribution       => :chi2,
                                                          :tail               => 'right',
                                                          :value              => 15.5073 })
            chi2.alpha.should be_within(ACCEPTABLE_ERROR).of(0.05)
          end
        end
      end

      describe 'attribute reader' do 
        it 'returns its tail when queried' do 
          chi2 = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 20,
                                                        :distribution       => :chi2,
                                                        :tail               => 'left',
                                                        :p                  => 0.05 })
          chi2.tail.should be('left')
        end
      end
    end

    describe 'F statistic' do 
      describe 'instantiation' do 
        context 'statistic value known' do 
          it 'instantiates with correct value' do 
            f = TestStatisticHelper::initialize_with({ :degrees_of_freedom_1 => 17,
                                                       :degrees_of_freedom_2 => 23,
                                                       :distribution         => :f,
                                                       :tail                 => 'right',
                                                       :p                    => 0.05 })
            f.should be_within(ACCEPTABLE_ERROR).of(2.091)
          end
        end

        context 'statistic value unknown' do 
          it 'instantiates with correct alpha' do 
            pending
          end
          
          it 'instantiates with correct tail' do 
            pending
          end

          it 'instantiates with correct distribution' do 
            pending
          end

          it 'instantiates with correct nu1 or nu2' do 
            pending
          end
        end
      end

      describe 'attribute reader' do 
        it 'returns its degrees of freedom when queried' do 
          f = TestStatisticHelper::initialize_with({ :degrees_of_freedom_1 => 8,
                                                     :degrees_of_freedom_2 => 24,
                                                     :distribution         => :f,
                                                     :tail                 => 'right',
                                                     :p                    => 0.05 })
          f.nu1.should equal(8)
          f.nu2.should equal(24)
        end

        it 'returns both sets of degrees of freedom when queried' do 
          pending 'future version'
          f = TestStatisticHelper::initialize_with({ :degrees_of_freedom_1 => 8,
                                                     :degrees_of_freedom_2 => 24,
                                                     :distribution         => :f,
                                                     :tail                 => 'right',
                                                     :p                    => 0.05 })
          f.nu.should equal( [8, 24])
        end
      end
    end
  end
end