class LuckyLuciano::Resource::Path
  attr_reader :resource, :sub_paths
  def initialize(resource, *sub_paths)
    @resource = resource
    @sub_paths = sub_paths
  end

  def =~(other)
    to_s =~ other
  end

  def [](*additional_sub_paths)
    sub_paths.push(*additional_sub_paths)
    self
  end

  def to_s
    resource.path(*sub_paths)
  end

  def ==(other)
    to_s == other.to_s
  end
end