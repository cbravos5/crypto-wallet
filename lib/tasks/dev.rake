namespace :dev do
  
  desc "Clear the db an fill it with seeds"
  task setup: :environment do
    if Rails.env.development?
      success_spinner("Cleaning db") {%x(rails db:drop:_unsafe)}
      success_spinner("Creating db") {%x(rails db:create)}
      success_spinner("Migrating db") {%x(rails db:migrate)}
      success_spinner("Getting mining types for db") {%x(rails dev:add_mining_types)}
      success_spinner("Getting coins for db") {%x(rails dev:add_coins)}
    else
      puts "Invalid task during non-dev enviroment"
    end
  end
  
  desc "Fill the db with coins"
  task add_coins: :environment do
    coins = []
    coins.push(get_seed_hash("Bitcoin","BTC","https://img2.gratispng.com/20180604/zya/kisspng-bitcoin-com-cryptocurrency-logo-zazzle-kibuba-btc-5b15aa1f157d09.468430171528146463088.jpg",MiningType.find_by(acronym:'PoW')))
    coins.push(get_seed_hash("Ethereum","ETH","https://img2.gratispng.com/20180411/bqe/kisspng-ethereum-blockchain-cryptocurrency-logo-coin-stack-5acdf53e613ac4.3193440815234471023983.jpg",MiningType.all.sample))
    coins.push(get_seed_hash("Litecoin","LTC","https://img2.gratispng.com/20180525/wal/kisspng-litecoin-cryptocurrency-bitcoin-logo-cryptocurrency-5b081f1979b524.5871818715272589054985.jpg",MiningType.all.sample))
    coins.push(get_seed_hash("Zcash","ZEC","data:image/png;base64,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",MiningType.all.sample))
    coins.push(get_seed_hash("Dash","DASH","https://i.pinimg.com/originals/b0/f5/ff/b0f5ff13b6449d68d7038bee35a1c6eb.png",MiningType.all.sample))
    
    
    coins.each do |coin|
      Coin.find_or_create_by!(coin)
    end
  end
  
  desc "Fill the db with mining types"
  task add_mining_types: :environment do
    mining_types = []
    mining_types.push(get_seed_hash("Proof of Work","PoW"))
    mining_types.push(get_seed_hash("Proof of Stake","PoS"))
    mining_types.push(get_seed_hash("Proof of Capacity","PoC"))
               
    mining_types.each do |type|
      MiningType.find_or_create_by!(type)
    end
    
  end
    
  def success_spinner(spin_text)
    spinner = TTY::Spinner.new("[:spinner] #{spin_text}")
    spinner.auto_spin
    yield
    spinner.success('(successful)')
  end
  
  def get_seed_hash(name,acronym,url = "0",mining_type = [])
    hash  = {}
    if url == "0" 
      hash =  {
                description: name,
                acronym: acronym
              }
    else
      hash = {
                description: name,
                acronym: acronym,
                url_image: url,
                mining_type: mining_type
             }
    end
    return hash
  end

end
