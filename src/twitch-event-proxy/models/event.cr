require "db"

class Event
  include DB::Serializable

  property timestamp : String
  property detail : String
end
