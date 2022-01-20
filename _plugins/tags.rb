module Tags
  class TagPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      tags = site.posts.docs.flat_map { |post| post.data['tags'] || [] }.uniq
      tags.to_set.each do |tag|
        site.pages << TagPage.new(site, site.source, tag, tags)
      end
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, base, tag, tags)
      @site = site
      @base = base
      @dir  = ""
      @name = "@#{tag}.html"

      self.process(@name)
      self.read_yaml(base, File.join("_layouts", "tags.html"))
      self.data['tag'] = tag
      self.data['title'] = "Posts in #{tag}"
      self.data['permalink'] = "@#{tag}.html"
      self.data['all_tags'] = tags
    end
  end
end
