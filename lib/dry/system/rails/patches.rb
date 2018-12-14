Dry::System::Container.class_eval do
  def require_component(component)
    return if key?(component.identifier)

    unless component.file_exists?(load_paths)
      raise FileNotFoundError, component
    end

    require_dependency component.path

    yield
  end
end

Dry::System::Container.instance_eval do
  def register(key, contents = nil, options = {}, &block)
    super(key, contents, { memoize: memoize? }.merge(options), &block)
  end

  def memoize?
    ::Rails.application.config.eager_load && ::Rails.application.config.cache_classes
  end
end
