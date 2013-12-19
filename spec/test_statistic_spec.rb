require_relative 'spec_helper'

class TestStatistic
  include TestStatisticHelper

  ACCEPTABLE_ERROR = 0.0005

  describe TestStatistic do
    describe 'general characteristics' do 
      it 'can be used in calculations like a float' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :p                  => 0.025,
                                                   :degrees_of_freedom => 10 })
        expect(t * 1.5).to be_instance_of(Float)
      end

      it 'can be initialized with :p, :alpha, or :significance_level as probability of Type I error' do 
        t1 = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                    :p                  => 0.025,
                                                    :degrees_of_freedom => 10 })
        t2 = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                    :alpha              => 0.025,
                                                    :degrees_of_freedom => 10 })
        t3 = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                    :significance_level => 0.025,
                                                    :degrees_of_freedom => 10 })
        expect(t1).to be_within(1e-10).of(t2)
        expect(t1).to be_within(1e-10).of(t3)
      end

      it 'can return absolute value without turning into a float' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :p                  => 0.025,
                                                   :degrees_of_freedom => 10 })
        absolute_value = t.abs
        expect(t).to be_instance_of(TestStatistic)
      end
    end

    describe 'attribute reader' do 
      it 'gives a hash of its own attributes' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :alpha              => 0.025,
                                                   :degrees_of_freedom => 10 })
        expect(t.attributes).to be_instance_of(Hash)
      end

      it 'only displays attributes relevant to its distribution' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 20,
                                                   :alpha              => 0.05,
                                                   :tail               => 'right' })
        expect(t.attributes).not_to have_key(:tail)
      end

      it 'returns its distribution' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :alpha              => 0.05,
                                                   :degrees_of_freedom => 12 })
        expect(t.distribution).to be(:t)
      end

      it 'returns its degrees of freedom' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :degrees_of_freedom => 25,
                                                   :alpha              => 0.025 })
        expect(t.degrees_of_freedom).to eql(25)
      end

      it 'responds to queries for #p, #alpha, or #p_value' do 
        t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                   :p                  => 0.05,
                                                   :degrees_of_freedom => 19 })
        expect(t.p).to eql(t.alpha)
        expect(t.p).to eql(t.p_value)
        expect(t.p).to eql(t.significance_level)
      end

      it 'returns its tail' do 
        f = TestStatisticHelper::initialize_with({ :distribution         => :f,
                                                   :tail                 => 'right',
                                                   :degrees_of_freedom_1 => 16,
                                                   :degrees_of_freedom_2 => 18,
                                                   :p                    => 0.05 })
        expect(f.tail).to eql('right')
      end
    end

    describe "t-statistic" do 
      describe "instantiation" do 
        context 'with statistic value unknown' do 
          it 'instantiates with the correct value' do 
            t = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                       :alpha              => 0.05,
                                                       :degrees_of_freedom => 18 })
            expect(t).to be_within(ACCEPTABLE_ERROR).of(-1.734)
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
            pending 'expanded functionality'
            t = TestStatisticHelper::initialize_with({ :distribution => :t,
                                                       :alpha        => 0.05,
                                                       :value        => -1.8595 })
            expect(t.nu).to eql(8)
          end

          it 'instantiates with correct distribution' do 
            pending("have to add this option to #initialize_with method")
            t = TestStatisticHelper::initialize_with({ :degrees_of_freedom => 19,
                                                       :value              => 2.093,
                                                       :p                  => 0.025 })
            expect(t.distribution).to be(:t)
          end
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
          it 'instantiates with correct alpha'
          
          it 'instantiates with correct tail'

          it 'instantiates with correct distribution'

          it 'instantiates with correct nu1 or nu2'
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