defmodule SX1509.Registers.KeypadEngine do
  use Wafer.Registers

  @moduledoc """
  This module provides a register mapping for SX1509's Debounce and Keypad Engine



  """
  @doc """
  RegDebounceConfig
  Debounce configuration register (default: 0x00)

  Bit | Setting
  ---: | :---
  7:3 | Unused
  2:0 | Debounce time (Cf. §4.6.1) <br> 000: 0.5ms x 2MHz/fOSC <br> 001: 1ms x 2MHz/fOSC <br> 010: 2ms x 2MHz/fOSC <br> 011: 4ms x 2MHz/fOSC <br> 100: 8ms x 2MHz/fOSC <br> 101: 16ms x 2MHz/fOSC <br> 110: 32ms x 2MHz/fOSC <br> 111: 64ms x 2MHz/fOSC
  """
  defregister(:debounce_config, 0x22, :rw)

  @doc """
  RegDebounceEnableB - Debounce enable register - I/O[15-8] (Bank B) (default: 0x00)
  RegDebounceEnableA - Debounce enable register - I/O[7-0] (Bank A) (default: 0x00)

  Enables debouncing for each [input-configured] IO
  0 : Debouncing is disabled
  1 : Debouncing is enabled
  """
  defregister(:debounce_enable, 0x23, 2)
end
