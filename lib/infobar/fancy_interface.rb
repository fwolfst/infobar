module Infobar::FancyInterface
  def ~
    reset
  end

  def +@
    progress by: 1
  end

  def +(by)
    progress by: by
  end

  def coerce(other)
    return self, other
  end

  def <<(item)
    progress by: 1
  end

  def add(*items)
    progress by: items.size
  end
  alias push add
end
