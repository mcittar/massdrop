class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    job = Url.find(args.first)
    begin
      url = HTTP.get(job.url)
      job.html = url.to_s
    rescue HTTP::ConnectionError => exception
      job.html = exception.to_s
    end
    job.status = true
    job.save
    job
  end
end
