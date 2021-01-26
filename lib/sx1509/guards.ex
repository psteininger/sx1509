defmodule SX1509.Guards do
  @moduledoc false
  defguard is_port_b(pin) when is_integer(pin) and pin >= 0 and pin <= 7
  defguard is_port_a(pin) when is_integer(pin) and pin >= 8 and pin <= 15
  defguard is_pin_number(pin) when is_integer(pin) and pin >= 0 and pin <= 15
end