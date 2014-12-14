require "slim"
require "uglifier"

# Prevent HTML minification in development
::Slim::Engine.set_default_options :pretty => true

# Minimum Sass number precision required by bootstrap-sass
::Sass::Script::Number.precision = [10, ::Sass::Script::Number.precision].max

# Add Bower to sprockets
after_configuration do
  sprockets.append_path File.join root.to_s, "bower_components"
end

# Asset paths
set :css_dir,     "stylesheets"
set :js_dir,      "javascripts"
set :images_dir,  "images"

# Prevent asset concatenation in development
set :debug_assets, true

# Set url root
set :url_root, build? ? "http://domain.tld/" : "http://0.0.0.0:4567/"

# Activate directory indexes for pretty urls
activate :directory_indexes

# Active sitemap generator
activate :search_engine_sitemap

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Activate gzip compression
activate :gzip

# Define 404 page
page "/404.html", :directory_index => false

# Deployment via middleman-deploy (usage: PASSWORD=password be middleman deploy)
activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method       = :ftp
  deploy.host         = "domain.tld"
  deploy.path         = "./"
  deploy.user         = "username"
  deploy.password     = ENV["PASSWORD"]
end

# Build-specific configuration
configure :build do


  # Minify Javascript
  activate :minify_javascript, :inline => true, :compressor => Uglifier.new(:mangle => false, :comments => :none)
    
  # For example, change the Compass output style for deployment
  activate :minify_css, :inline => true

  # Minify HTML
  activate :minify_html, remove_comments: false

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Auto-generate multiple favicon versions
  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source/images/favicons/_template')
    f.output_dir    = File.join(root, 'build/images/favicons')
    f.icons = {
      "favicon_template_hires.png" => [
        { icon: "favicon-152x152.png" },
        { icon: "favicon-120x120.png" },
        { icon: "favicon-76x76.png" },
        { icon: "favicon-60x60.png" },
      ],
      "favicon_template_lores.png" => [
        { icon: "favicon-32x32.png" },
        { icon: "favicon-16x16.png" },
        { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" }
      ]
    }
  end

end

helpers do

  # Title helper for html, facebook and twitter titles
  def title_helper
    (data.page.title ? "#{data.page.title} — " : "") + "Middleboy Boilerplate"
  end

  # Description helper for html, facebook and twitter descriptions
  def description_helper
    (data.page.description ? "#{data.page.description}" : "The ultimate Middleman Boilerplate with SASS, COFFEE, SLIM")
  end

  # Helper which generates <html> tag with conditional IE classes
  # https://gist.github.com/SteveBenner/a71f41e175f135b7d69b
  def conditional_html_tags(ie_versions, attributes={})
    # Create an array from given range that allows us to generate the code via simple iteration
    ie_versions = ie_versions.to_a.unshift(ie_versions.min - 1).push(ie_versions.max + 1)
    # Classes from user-provided String or Array are appended after the default ones
    extra_classes = attributes.delete(:class) { |key| attributes[key.to_s] }
 
    commented_html_tags = ie_versions.collect { |version|
      # A 'lt-ie' class is added for each supported IE version higher than the current one
      ie_classes  = (version+1..ie_versions.max).to_a.reverse.collect { |j| "lt-ie#{j}" }
      class_str   = ie_classes.unshift('no-js').push(extra_classes).compact.join ' '
      attr_str    = attributes.collect { |name, value| %Q[#{name.to_s}="#{value}"] }.join ' '
      html_tag    = %Q[<html class="#{class_str}"#{' ' unless attr_str.empty?}#{attr_str}>]
      # The first and last IE conditional comments are unique
      version_str = case version
        when ie_versions.min then
          "lt IE #{version + 1}"
        # Side effects in a `case` statement are rarely a good idea, but it makes sense here
        when ie_versions.max
          # This is rather crucial; the last HTML tag must be uncommented in order to be recognized
          html_tag.prepend('<!-->').concat('<!--') # Note that both methods are destructive
          "gt IE #{version - 1}"
        else "IE #{version}"
      end
      %Q[<!--[if #{version_str}]#{html_tag}<![endif]-->]
    }.flatten * $/
    # Return the output from given Slim blockm, wrapped in the code for commented HTML tags
    [commented_html_tags, yield, $/, '</html>'].join
  end

end