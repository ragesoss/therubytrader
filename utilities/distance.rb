class Distance
  def self.between point_one, point_two
    Math.sqrt(
      (point_one[0] - point_two[0])**2 + (point_one[1] - point_two[1])**2
    ).round
  end

  def self.to_nearest_town location
    $state[:towns].values.map do |town|
      Distance.between location, town.location
    end.min
  end
end
