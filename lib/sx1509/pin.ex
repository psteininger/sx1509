defmodule SX1509.Pin do
  @derive Wafer.DeviceID
  defstruct [:conn, :pin_number]
#  import SX1509.Guards
  import Wafer.Guards, except: [is_pin_number: 1]
#  alias SX1509.{Commands, Pin}
  alias Wafer.GPIO
  @behaviour Wafer.Conn

  @moduledoc """
  A connection to a GPIO pin on an MCP23017 device.
  """

  @type t :: %__MODULE__{conn: SX1509.t(), pin_number: SX1509.pin_number()}

  @type options :: [option]
  @type option ::
          {:conn, SX1509.t()}
          | {:pin_number, SX1509.pin_number()}
          | {:direction, GPIO.pin_direction()}


end