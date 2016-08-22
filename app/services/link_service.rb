class LinkService
  def self.generate_anonymous_link_hash
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    hash_url = (0...10).map { o[rand(o.length)] }.join
    generate_anonymous_link_hash if Link.find_by_hash_url(hash_url)

    hash_url
  end
end