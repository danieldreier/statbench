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
        z1 = TestStatisticHelper::initialize_with({ :distribution       => :z,
                                                    :p                  => 0.025 })
        z2 = TestStatisticHelper::initialize_with({ :distribution       => :z,
                                                    :alpha              => 0.025 })
        z3 = TestStatisticHelper::initialize_with({ :distribution       => :z,
                                                    :significance_level => 0.025})
        expect(z1).to be_within(1e-10).of(z2)
        expect(z1).to be_within(1e-10).of(z3)
      end

      it 'can return absolute value without turning into a float' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                    :p           => 0.025 })
        absolute_value = z.abs
        expect(z).to be_instance_of(TestStatistic)
      end
    end

    describe 'attribute reader' do 
      it 'gives a hash of its own attributes' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :alpha        => 0.025 })
        expect(z.attributes).to be_instance_of(Hash)
      end

      it 'only displays attributes relevant to its distribution' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 20,
                                                   :alpha              => 0.05,
                                                   :tail               => 'right' })
        expect(t.attributes).not_to have_key(:tail)
      end

      it 'returns its distribution' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :alpha        => 0.05 })
        expect(z.distribution).to be(:z)
      end

      it 'returns its degrees of freedom' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 25,
                                                   :alpha              => 0.025 })
        expect(t.degrees_of_freedom).to eql(25)
      end

      it 'responds to queries for #p, #alpha, or #p_value' do 
        z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                   :p            => 0.05 })
        expect(z.p).to eql(z.alpha)
        expect(z.p).to eql(z.p_value)
        expect(z.p).to eql(z.significance_level)
      end

      it 'returns its tail' do 
        chi2 = TestStatisticHelper::initialize_with({ :distribution       => :chi2,
                                                      :tail               => 'right',
                                                      :degrees_of_freedom => 16,
                                                      :p                  => 0.05 })
        expect(chi2.tail).to eql('right')
      end
    end

    describe 'z-statistic' do 
      describe 'instantiation' do 
        context 'with actual statistic value unknown' do 
          it 'instantiates with the correct z-value' do 
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :alpha        => 0.025 })
            expect(z.abs).to be_within(ACCEPTABLE_ERROR).of(1.96)
          end
        end

        context 'with actual statistic value unknown' do 
          it 'instantiates with the correct alpha given value' do 
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :value        => 1.96 })
            expect(z.alpha).to be_within(ACCEPTABLE_ERROR).of(0.025)
          end

          it 'instantiates with z-distribution given alpha and value' do 
            pending "additional Distribution functionality"
            z = TestStatisticHelper::initialize_with({ :value => 1.96,
                                                       :alpha => 0.025 })
            expect(z.distribution).to be(:z)
          end

          it 'instantiates with alpha given distribution and value' do 
            pending "additional Distribution functionality"
            z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :value        => 1.96 })
            expect(z.alpha).to be_within(ACCEPTABLE_ERROR).of(0.025)
          end
        end
      end

      describe "attributes" do 
        it 'returns nil when queried for degrees of freedom' do 
          z = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                     :alpha        => 0.025 })
          expect(z.degrees_of_freedom).to be(nil)
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
            expect(t).to be_within(ACCEPTABLE_ERROR).of(1.734)
          end
        end

        context 'with statistic value known' do 
          it 'instantiates with correct alpha' do 
            t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                       :degrees_of_freedom => 8,
                                                       :value              => 1.8595 })
            expect(t.alpha).to be_within(ACCEPTABLE_ERROR).of(0.05)
          end

          it 'instantiates with correct nu' do 
            t = TestStatisticHelper::initialize_with({ :distribution => :t,
                                                       :alpha        => 0.05,
                                                       :value        => -1.8595 })
            expect(t.nu).to eql(8)
          end

          it 'instantiates with correct distribution' do 
            t = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 19,
                                                       :value              => 2.093,
                                                       :p                  => 0.025 })
            expect(t.distribution).to be(:t)
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
            expect(chi2).to be_within(ACCEPTABLE_ERROR).of(26.296)
          end
        end

        context 'with statistic value unknown' do 
          it 'instantiates with correct nu' do 
            chi2 = TestStatisticHelper::initialize_with({ :distribution => :chi2,
                                                          :tail         => 'left',
                                                          :value        => 17.708,
                                                          :p            => 0.05 })
            expect(chi2.degrees_of_freedom).to eql(29)
          end

          it 'instantiates with correct alpha' do 
            chi2 = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 8,
                                                          :distribution       => :chi2,
                                                          :tail               => 'right',
                                                          :value              => 15.5073 })
            expect(chi2.alpha).to be_within(ACCEPTABLE_ERROR).of(0.05)
          end
        end
      end

      describe 'attribute reader' do 
        it 'returns its tail when queried' do 
          chi2 = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 20,
                                                        :distribution       => :chi2,
                                                        :tail               => 'left',
                                                        :p                  => 0.05 })
          expect(chi2.tail).to be('left')
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
            expect(f).to be_within(ACCEPTABLE_ERROR).of(2.091)
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
          expect(f.nu1).to equal(8)
          expect(f.nu2).to equal(24)
        end

        it 'returns both sets of degrees of freedom when queried' do 
          pending 'future version'
          f = TestStatisticHelper::initialize_with({ :degrees_of_freedom_1 => 8,
                                                     :degrees_of_freedom_2 => 24,
                                                     :distribution         => :f,
                                                     :tail                 => 'right',
                                                     :p                    => 0.05 })
          expect(f.nu).to eql( [8, 24])
        end
      end
    end
  end
end