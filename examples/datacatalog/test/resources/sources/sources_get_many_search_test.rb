require File.expand_path(File.dirname(__FILE__) + '/../../helpers/resource_test_helper')

class SourcesGetManySearchResourceTest < ResourceTestCase

  include DataCatalog

  def app; Sources end

  before do
    Source.destroy_all unless Source.count == 0
    @sources = [
      create_source(
        :url => "http://www.data.gov/details/723",
        :title => %{2008 Early Release Toxics Release Inventory data for the state of New York"},
        :description => %{Preliminary Toxics Release Inventory Data in the "Basic Plus" file format. The Toxics Release Inventory (TRI) is a publicly available EPA database that contains information on toxic chemical releases and waste management activities reported annually by certain industries as well as federal facilities.}
      ),
      create_source(
        :url => "http://www.data.gov/details/788",
        :title => %{Renal Dialysis Facility Medicare Cost Report Data - FY 2007},
        :description => %{A collection of Renal Dialysis Facility Medicare cost report data from the CMS Form 265-94.}
      ),
      create_source(
        :url => "http://www.data.gov/details/431",
        :title => %{Interest Rate Statistics - Daily Treasury Yield Curve Rates (1998)},
        :description => %{Treasury Yield Curve Rates. These rates are commonly referred to as "Constant Maturity Treasury" rates, or CMTs. Yields are interpolated by the Treasury from the daily yield curve. This curve, which relates the yield on a security to its time to maturity is based on the closing market bid yields on actively traded Treasury securities in the over-the-counter market. These market yields are calculated from composites of quotations obtained by the Federal Reserve Bank of New York. The yield values are read from the yield curve at fixed maturities, currently 1, 3 and 6 months and 1, 2, 3, 5, 7, 10, 20, and 30 years. This method provides a yield for a 10 year maturity, for example, even if no outstanding security has exactly 10 years remaining to maturity.}
      ),
      create_source(
        :url => "http://www.data.gov/details/404",
        :title => %{Interest Rate Statistics - Daily Treasury Bills Rates (Current month)},
        :description => %{Daily Treasury Bill Rates: These rates are the daily secondary market quotation on the most recently auctioned Treasury Bills for each maturity tranche (4-week, 13-week, 26-week, and 52-week) that Treasury currently issues new Bills. Market quotations are obtained at approximately 3:30 PM each business day by the Federal Reserve Bank of New York. The Bank Discount rate is the rate at which a Bill is quoted in the secondary market and is based on the par value, amount of the discount and a 360-day year. The Coupon Equivalent, also called the Bond Equivalent, or the Investment Yield, is the bill's yield based on the purchase price, discount, and a 365- or 366-day year. The Coupon Equivalent can be used to compare the yield on a discount bill to the yield on a nominal coupon bond that pays semiannual interest.}
      ),
      create_source(
        :url => "http://www.data.gov/details/311",
        :title => %{2007 Crime in the United States},
        :description => %{Extraction of offense, arrest, and clearance data as well as law enforcement staffing information from the FBI's Uniform Crime Reporting (UCR) Program.}
      ),
      create_source(
        :url => "http://www.data.gov/details/123",
        :title => %{Airline On-Time Performance and Causes of Flight Delays},
        :description => %{This table contains on-time arrival data for non-stop domestic flights by major air carriers, and provides such additional items as departure and arrival delays, origin and destination airports, flight numbers, scheduled and actual departure and arrival times, cancelled or diverted flights, taxi-out and taxi-in times, air time, and non-stop distance.}
      ),
    ]
  end

  after do
    @sources.each { |x| x.destroy } if @sources
  end
  
  context "search=arrest" do
    before do
      @search_params = { :search => "arrest" }
    end
  
    context "get /" do
      context "anonymous" do
        before do
          get "/", @search_params
        end
    
        use "return 401 because the API key is missing"
      end
    
      context "incorrect API key" do
        before do
          get "/", @search_params.merge(:api_key => BAD_API_KEY)
        end
    
        use "return 401 because the API key is invalid"
      end
    end
  
    %w(basic curator admin).each do |role|
      context "#{role} : get /" do
        before do
          get "/", @search_params.merge(:api_key => api_key_for(role))
        end
  
        use "return 200 Ok"
  
        test "body should have 1 source" do
          assert_equal 1, parsed_response_body.length
        end
        
        test "body should have correct source" do
          assert_equal %{2007 Crime in the United States},
            parsed_response_body[0]['title']
        end
        
        docs_properties %w(title url raw categories id created_at updated_at)
      end
    end
  end
  
  context "search=quotations" do
    before do
      @search_params = { :search => "quotations" }
    end
  
    %w(basic).each do |role|
      context "#{role} : get /" do
        before do
          get "/", @search_params.merge(:api_key => api_key_for(role))
        end
  
        use "return 200 Ok"
        
        test "body should have correct sources" do
          titles = parsed_response_body.map { |x| x['title'] }
          assert_equal 2, titles.length
          assert_include %{Interest Rate Statistics - Daily Treasury Yield Curve Rates (1998)}, titles
          assert_include %{Interest Rate Statistics - Daily Treasury Bills Rates (Current month)}, titles
        end
      end
    end
  end

end
