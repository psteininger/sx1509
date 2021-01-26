defmodule SX1509.Commands do
  use Bitwise

  import SX1509.Guards
#  import Wafer.Twiddles
  alias SX1509.Registers
  alias Wafer.{Conn, GPIO}
  @moduledoc """
  Commands for interacting with the SX1509 device.

  These commands wrap the registers defined in `SX1509.Registers.DeviceIO`, `SX1509.Registers.KeypadEngine` and
  `SX1509.Registers.LEDDriver` allowing you to achieve higher-level effects without
  worrying about the register mapping or bit twiddling.
  """

  @type pin_polarity :: :normal | :inverted
  @type interrupt_polarity :: :active_high | :active_low

  @doc """
  Initialise the SX1509 with defaults.
  """

  def init(
        %{
          conn: conn,
          int_pin: _int_pin
        } = device
      ) do
    with {:ok, conn} <- Registers.Device.write_reset(conn, <<0x12>>),
         {:ok, conn} <- Registers.Device.write_reset(conn, <<0x34>>),
         do: {:ok, %{device | conn: conn}}
  end

  @doc """
  Configures the specified pin as either an input or an output.
  """
  @spec pin_direction(Conn.t(), SX1509.pin_number(), GPIO.pin_direction()) ::
          {:ok, Conn.t()} | {:error, reason :: any}
  def pin_direction(%{conn: conn, dir: dir} = device, pin, :out) do
    with bytes <- clear_pin(dir, pin),
         {:ok, conn} <- Registers.IO.write_dir(conn, <<bytes::16>>),
         do: {:ok, %{device | conn: conn, dir: <<bytes::16>>}}
  end

  def pin_direction(%{conn: conn, dir: dir} = device, pin, :in) do
    with bytes <- set_pin(dir, pin),
         {:ok, conn} <- Registers.IO.write_dir(conn, <<bytes::16>>),
         do: {:ok, %{device | conn: conn, dir: <<bytes::16>>}}
  end

  @doc """
  Sets the data value of the pin.
  """
  @spec pin_data(Conn.t(), SX1509.pin_number(), GPIO.pin_value()) ::
          {:ok, Conn.t()} | {:error, reason :: any}
  def pin_data(%{conn: conn, data: data} = device, pin, value) do
    with bytes <- set_pin(data, pin, value),
         {:ok, conn} <- Registers.IO.write_data(conn, <<bytes::16>>),
         do: {:ok, %{device | conn: conn, data: <<bytes::16>>}}
  end

  @doc """
  Gets the data value of the pin.
  """
  @spec pin_data(Conn.t(), SX1509.pin_number()) ::
          {:ok, Conn.t()} | {:error, reason :: any}
  def pin_data(%{conn: conn} = device, pin) do
    with {:ok, <<bytes::16>>} <- Registers.IO.read_data(conn) do
      value = bytes >>> pin &&& 1
      {:ok, value, %{device | conn: conn, data: <<bytes::16>>}}
    end
  end

  @doc """
  Disables input for specified pin number.
  """
  @spec disable_input(Conn.t(), SX1509.pin_number()) ::
          {:ok, Conn.t()} | {:error, reason :: any}
  def disable_input(%{conn: conn, input_disable: input_disable} = device, pin) do
    with bytes <- set_pin(input_disable, pin),
         {:ok, conn} <- Registers.IO.write_input_disable(conn, <<bytes::16>>),
         do: {:ok, %{device | conn: conn, dir: <<bytes::16>>}}
  end

  @doc """
  Enables input for specified pin number.
  """
  @spec enable_input(Conn.t(), SX1509.pin_number()) ::
          {:ok, Conn.t()} | {:error, reason :: any}
  def enable_input(%{conn: conn, input_disable: input_disable} = device, pin) do
    with bytes <- clear_pin(input_disable, pin),
         {:ok, conn} <- Registers.IO.write_input_disable(conn, <<bytes::16>>),
         do: {:ok, %{device | conn: conn, dir: <<bytes::16>>}}
  end

  defp clear_pin(<<bytes::16>>, pin) when is_pin_number(pin) do
    bytes &&& ~~~ (1 <<< pin)
  end

  defp set_pin(<<bytes::16>>, pin) when is_pin_number(pin) do
    bytes ||| 1 <<< pin
  end

  def set_pin(bytes, pin, 1), do: set_pin(bytes, pin)
  def set_pin(bytes, pin, 0), do: clear_pin(bytes, pin)
end


