module ReportingHelpers

  # Need the unless guard b/c this code is dynamically loaded
  # and can result in ruby warnings if it attempts to define the
  # constant again
  SECONDS_IN_24HOURS = 86400 unless const_defined?(:SECONDS_IN_24HOURS)
  # Approximate, b/c of course the length of a month can vary
  SECONDS_IN_3MONTHS = 7889230 unless const_defined?(:SECONDS_IN_3MONTHS)

  def apply_time_args()
    if config[:start_time] && config[:end_time]
      start_time, end_time = convert_to_unix_timestamps()
    else
      start_time, end_time = last_24hours_time_window()
    end

    return start_time, end_time
  end

  def last_24hours_time_window()
    # Time is calculated as a unix timestamp
    end_time = Time.now.to_i
    start_time = end_time - SECONDS_IN_24HOURS
    return start_time, end_time
  end

  def check_start_and_end_times_provided()
    if config[:start_time] && !config[:end_time]
      ui.error("The start_time option was provided, but the end_time option was not. If one is provided, the other is required.")
      exit 1
    elsif config[:end_time] && !config[:start_time]
      ui.error("The end_time option was provided, but the start_time option was not. If one is provided, the other is required.")
      exit 1
    end
  end

  def convert_to_unix_timestamps()
    if config[:unix_timestamps]
      start_time = config[:start_time].to_i
      end_time = config[:end_time].to_i
    else
      # Take user supplied input, assumes it is in a valid date format,
      # convert to a date object to ensure we have the proper date format for
      # passing to the time object (but converting is not a validation step,
      # so bad user input will still be bad)
      # then convert to a time object, and then convert to a unix timestamp
      # An error could potentially be thrown if the conversions don't work
      # This does work on windows - to_i on time even on windows still returns a unix timestamp
      # Verified on ruby 1.9.3 on a windows 2000 ami on aws
      start_time = Time.parse(Date.strptime(config[:start_time], '%m-%d-%Y').to_s).to_i
      end_time = Time.parse(Date.strptime(config[:end_time], '%m-%d-%Y').to_s).to_i
    end

    return start_time, end_time
  end

  def check_3month_window(start_time, end_time)
    # start_time and end_time are unix timestamps
    if (end_time - start_time) > SECONDS_IN_3MONTHS
      ui.error("Requesting information for more than three months at a time is disallowed. Please try a smaller timeframe.")
      exit 1
    end
  end

end
