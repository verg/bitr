class MessageParser
  attr_reader :length, :type

  MESSAGE_TYPES  = { 5 => :bitfield }

  def initialize(message)
    @message = message
    @length = @message[0..3].unpack("N").first
  end

  def get_type
    @message
  end

  def type
    return :keep_alive if @length == 0

    id = @message[4].unpack("C").first
    MESSAGE_TYPES[id]
  end
end
