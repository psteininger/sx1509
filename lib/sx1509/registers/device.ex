defmodule SX1509.Registers.Device do
  use Wafer.Registers
  @moduledoc """
  This module provides a selective register mapping for SX1509 Device related registers.


  """
  @doc """
  RegClock - Clock management register (default: 0x00)

  This is a single-byte register

  Bit | Setting
  ---: | :---
     7 | Unused
   6:5 | Oscillator frequency (fOSC) source <br> 00 : OFF. LED driver, keypad engine and debounce features are disabled. <br>01 : External clock input (OSCIN)<br>10 : Internal 2MHz oscillator<br>11 : Reserved
     4 | OSCIO pin function (Cf. §4.8)<br> 0 : OSCIO is an input (OSCIN)<br> 1 : OSCIO is an output (OSCOUT)
   3:0 | Frequency of the signal output on OSCOUT pin:<br>0x0 : 0Hz, permanent "0" logical level (GPO)<br>0xF : 0Hz, permanent "1" logical level (GPO)<br>Else : fOSCOUT = fOSC/(2^(RegClock[3:0]-1))
  """
  defregister(:clock, 0x1E, :rw)


  @doc """
  RegMisc - Miscellaneous device settings register (default: 0x00)

  This is a single-byte register

  TODO:  details to be transcribed from data sheet (tables are bloody hard in Markdown)
  """
  defregister(:misc, 0x1F, :rw)

  @doc """
  RegReset - Software reset register (default: 0x00)

  This is a single-byte register

  Writing consecutively 0x12 and 0x34 will reset the device (same as POR). Always reads 0.
  """
  defregister(:reset, 0x7D, :rw)

  @doc """
  RegLEDDriverEnableB - LED driver enable register - I/O[15-8] (Bank B) (default: 0x00)
  RegLEDDriverEnableA - LED driver enable register - I/O[7-0] (Bank A) (default: 0x00)

  Enables LED Driver for each [output-configured] IO
  0 : LED Driver is disabled
  1 : LED Driver is enabled
  """
  defregister(:led_driver_enable_b, 0x20, :rw)
  defregister(:led_driver_enable_a, 0x21, :rw)


end
