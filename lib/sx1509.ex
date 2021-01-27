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
  alias Wafer.{Driver.Circuits, GPIO}
  @behaviour Conn

  @opaque t :: %SX1509{}
  @type pin_number :: 0..15
  @type options :: [option]
  @type option :: {:conn, Conn.t()} | {:int_pin, Conn.t()}

  @moduledoc """
  The [SX1509](http://cdn.sparkfun.com/datasheets/BreakoutBoards/sx1509.pdf) is a 16 pin
  GPIO expander chip connected over I2C. It also includes an LED driver and keypad engine.
  This is an indirect port of C++ and Python drivers using Wafer for structure.
  """

  @doc """
  Acquire a connection to the SX1509 device.


  ## Options

    - `conn` (required) the I2C connection to the device.
    - `bus_name` (optional) I2C bus name, defaults to @default_bus_name
    - `bus_address` (optional) I2C bus name, defaults to @default_address, must be one of @valid_addresses
    - `int_pin` (optional) the GPIO connection to the INT pin.
  """

  # Taken from Section 4.5 of the data sheet
  @valid_addresses [0x3E, 0x3F, 0x70, 0x71]
  @default_address 0x3E
  @default_bus_name "i2c-1"

  @spec acquire(options) :: {:ok, Conn.t()} | {:error, reason :: any}
  def acquire(opts) when is_list(opts) do
    with {:ok, bus_address} <- get_bus_address(opts),
         {:ok, bus_name} <- Keyword.fetch(opts, :bus_name, @default_bus_name),
         {:ok, i2c} <- Circuits.I2C.acquire(bus_name: bus_name, address: bus_address) do

      with {:ok, int_pin} <- Keyword.fetch(opts, :int_pin),
           {:ok, gpio} <- Circuits.GPIO.acquire(pin: int_pin, direction: :in),
           {:ok, gpio} <- GPIO.enable_interrupt(gpio, :both) do
        {:ok, %SX1509{conn: i2c, int_pin: gpio}}
      else
        :error -> {:ok, %SX1509{conn: i2c}}
      end
    end
  end

  defp get_bus_address(opts) do
    case Keyword.fetch(opts, :bus_address) do
      {:ok, addr} when addr in @valid_addresses ->
        {:ok, addr}

      {:ok, addr} ->
        {
          :error,
          "I2C address #{inspect(addr)} is not valid according to revision 1 of the SX1509 datasheet."
        }

      :error ->
        {:ok, @default_address}
    end
  end



  @doc """
  Release the connection to the SX1509 device.
  """
  @spec release(t) :: :ok | {:error, reason :: any}
  def release(%SX1509{}), do: :ok

end