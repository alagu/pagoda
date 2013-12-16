module Jekyll
  class Site

    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object only for draft items
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_drafts(dir = '')
      if self.respond_to? 'get_entries'
        entries = get_entries(dir, '_posts')
      else
        base = File.join(self.source, dir, '_posts')
        return unless File.exists?(base)
        entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }
      end

      drafts  = []

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self, self.source, dir, f)

          if (not post.published )
            drafts << post
          end
        end
      end

      drafts
    end

  end
end