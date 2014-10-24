require_relative './../../app/redis/redisloyaltystat'
require_relative './../../app/redis/util/redis_lreg_util'
require_relative './../linear_regression_log'

module Recommender
class LoyaltyRecommender < BaseRecommender

def self.description
	"identifies recommendations based on a site's audience loyalty (repeat, returning and top visitors.)"
end

def self.value_description
  "site's audience behavior"
end

def self.source
  "source"
end

def welcoming_type
  WelcomingType::AUDIENCE
end

def self.event
  "change in returning visitors"
end

def event_title
  'You have an increasing trend in {CATEGORY} visitors'
end

def event_tokens
  {
    '{CATEGORY}'  => recommendation.recommender_value.capitalize
  }
end

def event_description_tokenized
  recommender_amount = amount_formatted
  '{AMOUNT} {CATEGORY} ' + 'Visitor'.pluralize(recommender_amount) + ' in the last week'
end

def event_description
  tokenized = event_description_tokenized     
  apply_tokens(tokenized, all_tokens)      
end

def self.targeter
	Targeter::LoyaltyTargeter
end

def self.logstore(site,dbcat,reg,avg,ary,aryraw,recommender_amount)
  @@logloyalty.show_data_reg(site.id,dbcat,reg,avg,ary,aryraw,recommender_amount)
  Recommendation.create(account_id: site.account_id,
                        site_id: site.id,
                        recommendable_id: 0,
                        recommender_type: self.name.demodulize,
                        recommender_value: dbcat,
                        recommender_amount: recommender_amount,
                        recommendation_type_id: 1,
                        welcome_template_id: 0,
                        published: true,
                        details: {})
end

CATEGORY_OPTIONS = {
  'category' => {
    'Returning' => {
      :trend => 0.0250,
      :slope => 0,
      :significance => 1.0,
      :avg => 50},
    'Repeat' => {
      :trend => 0.0250,
      :slope => 0,
      :significance => 1.0,
      :avg => 25},
    'Top' => {
      :trend => 0.0250,
      :slope => 0,
      :significance => 1.0,
      :avg => 10}
  }
}
@@category_options = CATEGORY_OPTIONS

def self.catDecide(category,reg,avg)
  options =           @@category_options['category'][category]
  trend_limit         = options[:trend]
  slope_limit         = options[:slope]
  significance_limit  = options[:significance]
  avg_limit           = options[:avg]
  significance = (reg.trend.last / avg)
  trend_lift   = (reg.slope / reg.trend.last)
  if trend_lift > trend_limit && reg.slope > slope_limit && avg > avg_limit
    true
  else
    false
  end
  # uncomment to see all data
  # true
end

def self.process(site,ary,dbcat,aryraw)
  if ary != RedisLoyaltyStat::NODATA && ary.length > 5  # must have 6 weeks of data
    recommender_amount = RedisUtil::get_max_value_in_array_subset(aryraw,5) # last 5 weeks
    results = RedisUtil::get_average_statistics(aryraw)
    avg = results[:avg].to_f
    reg = LinearRegression.new(ary)
    mybool = catDecide(dbcat,reg,avg)
    if mybool
      logstore(site,dbcat,reg,avg,ary,aryraw,recommender_amount)
    end
  end
end

def self.getCategoryForDayOfWeek(day)
  if (day == 'Monday')
    RedisLoyaltyStat::RETURNING
  elsif (day == 'Tuesday')
    RedisLoyaltyStat::REPEAT
  elsif (day == 'Wednesday')
    RedisLoyaltyStat::TOP
  else
    'NOTODAY'
  end
end

def self.checksave_category(site)
  t = Time.now
  day = t.strftime("%A")
  category = getCategoryForDayOfWeek(day)
  unless category == 'NOTODAY'
    rls = RedisLoyaltyStat.new
    #
    # You should get back the raw data here for the particular category so that it can
    # be shown in the logger for debugging purposes and used to persist to Postgresql
    #
    rawdata = rls.process_all_category_data(site.id.to_s)
    data = rls.process_all_category_data_normalized(rawdata)
    if data.class.name == 'Symbol' && data.to_s == RedisLoyaltyStat::NODATA.to_s
      return RedisLoyaltyStat::NODATA
    end
    aryraw = rawdata[category]
    ary = data[category]
    dbcat = rls.getCatString(category)
    process(site,ary,dbcat,aryraw)
  end
end

def self.showrawdata(site)
  catary = [RedisLoyaltyStat::TOP, RedisLoyaltyStat::REPEAT, RedisLoyaltyStat::RETURNING, :visit]
  rls = RedisLoyaltyStat.new
  data = rls.process_all_category_data(site.id.to_s)
  if data.class.name == 'Symbol' && data.to_s == RedisLoyaltyStat::NODATA.to_s
    return RedisLoyaltyStat::NODATA
  end
  puts; puts site.id.to_s;
  catary.each do |cat|
    ary = data[cat]
    print cat, ' ', ary; puts
  end
end

def self.recommend(options = {})
  @@logloyalty = LinearRegressionLog.new("#{Rails.root}/log/loyalty_recommendender.log")
  totalcount = 0  
  sites = Site.all.sort
  #sites = Site.find([232, 253, 257])
  sites.each do |site|
    accountid = site.account_id
    if Account.exists?(accountid)
      totalcount += 1
      #siteid_bool = [5,20].include? site.id
      siteid_bool = true
      if siteid_bool && site.live == true
        #showrawdata(site)
        checksave_category(site)
      end
    end
  end
  print 'Out of total siteids = ',totalcount; puts
  puts 'end of recommend method'; puts
  end # method
  end # class
end # module
