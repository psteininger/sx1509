defmodule SX1509 do
  @derive Wafer.DeviceID
  defstruct conn: nil,
            input_disable: <<0, 0>>,
            long_slew: <<0, 0>>,
            low_drive: <<0, 0>>,
            pull_up: <<0, 0>>,
            pull_down: <<0, 0>>,
            open_drain: <<0, 0>>,
            polarity: <<0, 0>>,
            dir: <<0xff, 0xff>>,
            data: <<0xff, 0xff>>,
            interrupt_mask: <<0xff, 0xff>>,
            sense_high_low: <<0, 0, 0, 0>>,
            interrupt_source: <<0, 0>>,
            event_status: <<0, 0>>,
            int_pin: nil

  alias Wafer.Conn
  @behaviour Conn

  @opaque t :: %SX1509{}
  @type pin_number :: 0..15
  @type options :: [option]
  @type option :: {:conn, Conn.t()} | {:int_pin, Conn.t() }

  @moduledoc """
  The [SX1509](http://cdn.sparkfun.com/datasheets/BreakoutBoards/sx1509.pdf) is a 16 pin
  GPIO expander chip connected over I2C. It also includes an LED driver and keypad engine.
  This is an indirect port of C++ and Python drivers using Wafer for structure.
  """

  @doc """
  Acquire a connection to the SX1509 device.


  ## Options

    - `conn` (required) the I2C connection to the device.
    - `int_pin` (optional) the GPIO connection to the INT pin.
  """
  @spec acquire(options) :: {:ok, Conn.t()} | {:error, reason :: any}
  def acquire(opts) when is_list(opts) do
    with {:ok, conn} <- Keyword.fetch(opts, :conn),
         int_pin <- Keyword.get(opts, :int_pin),
         do: {:ok, %SX1509{conn: conn, int_pin: int_pin}}
  end

  @doc """
  Release the connection to the SX1509 device.
  """
  @spec release(t) :: :ok | {:error, reason :: any}
  def release(%SX1509{}), do: :ok

end