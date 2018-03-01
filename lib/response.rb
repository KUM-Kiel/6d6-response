module Response
  class Blockette
    def float f
      "% .6E" % f
    end
  end

  class PolesZeros < Blockette
    def initialize zeros, poles, options = {}
      @poles = poles
      @zeros = zeros
      @type = options[:type] || 'A'
      @norm_a = options[:norm_a] || 1.0
      @norm_f = options[:norm_f] || 1.0
      @unit_in = options[:unit_in] || 'COUNTS - Digital Counts'
      @unit_out = options[:unit_out] || 'COUNTS - Digital Counts'
    end

    def to_resp stage_number
      s = \
      "#\n" \
      "# Response (Poles & Zeros)\n" \
      "# ------------------------\n" \
      "#\n" \
      "B053F03     Transfer function type:                 #{@type}\n" \
      "B053F04     Stage sequence number:                  #{stage_number}\n" \
      "B053F05     Response in units lookup:               #{@unit_in}\n" \
      "B053F06     Response out units lookup:              #{@unit_out}\n" \
      "B053F07     A0 normalization factor:               #{float @norm_a}\n" \
      "B053F08     Normalization frequency:               #{float @norm_f}\n" \
      "B053F09     Number of zeroes:                       #{@zeros.count}\n" \
      "B053F14     Number of poles:                        #{@poles.count}\n" \
      "#            Complex zeroes:\n" \
      "#             i  real          imag          real_error    imag_error\n"
      @zeros.each_with_index do |z, i|
        s << \
        "B053F10-13  #{"%3d" % i} #{float z.real} #{float z.imag}  0.000000E+00  0.000000E+00\n"
      end
      s << \
      "#            Complex poles:\n" \
      "#             i  real          imag          real_error    imag_error\n"
      @poles.each_with_index do |p, i|
        s << \
        "B053F15-18  #{"%3d" % i} #{float p.real} #{float p.imag}  0.000000E+00  0.000000E+00\n"
      end
      s
    end
  end

  class Coefficients < Blockette
    def initialize coefficients, options = {}
      @coefficients = coefficients
      @type = options[:type] || 'A'
      @unit_in = options[:unit_in] || 'COUNTS - Digital Counts'
      @unit_out = options[:unit_out] || 'COUNTS - Digital Counts'
    end

    def to_resp stage_number
      s = \
      "#\n" \
      "# Response (Coefficients)\n" \
      "# -----------------------\n" \
      "#\n" \
      "B054F03     Response type:                          #{@type}\n" \
      "B054F04     Stage sequence number:                  #{stage_number}\n" \
      "B054F05     Response in units lookup:               #{@unit_in}\n" \
      "B054F06     Response out units lookup:              #{@unit_out}\n" \
      "B054F07     Number of numerators:                   #{@coefficients.count}\n" \
      "#            Numerators:\n" \
      "#             i  value         error\n"
      @coefficients.each_with_index do |c, i|
        s << \
        "B054F08-09  #{"%3d" % i} #{float c}  0.000000E+00\n"
      end
      s << \
      "B054F10     Number of denominators:                 #{0}\n" \
      "#            Denominators:\n" \
      "#             i  value         error\n"
      s
    end
  end

  class FIR < Blockette
    def initialize coefficients, options = {}
      if coefficients.reverse == coefficients
        if coefficients.count.even?
          @coefficients = coefficients[0, coefficients.count / 2]
          @symmetry = 'C'
        else
          @coefficients = coefficients[0, coefficients.count / 2 + 1]
          @symmetry = 'B'
        end
      else
        @coefficients = coefficients
        @symmetry = 'A'
      end
      @name = options[:name] || ''
      @unit_in = options[:unit_in] || 'COUNTS - Digital Counts'
      @unit_out = options[:unit_out] || 'COUNTS - Digital Counts'
    end

    def to_resp stage_number
      s = \
      "#\n" \
      "# FIR Response\n" \
      "# ------------\n" \
      "#\n" \
      "B061F03     Stage sequence number:                  #{stage_number}\n" \
      "B061F04     Response Name:                          #{@name}~\n" \
      "B061F05     Symmetry Code:                          #{@symmetry}\n" \
      "B061F06     Response in units lookup:               #{@unit_in}\n" \
      "B061F07     Response out units lookup:              #{@unit_out}\n" \
      "B061F08     Number of Coefficients:                 #{@coefficients.count}\n" \
      "#            Coefficients:\n" \
      "#             i  value\n"
      @coefficients.each_with_index do |c, i|
        s << \
        "B061F09     #{"%3d" % i} #{'% .7E' % c}\n"
      end
      s
    end
  end

  class Gain < Blockette
    attr_reader :gain

    def initialize gain, options = {}
      @gain = gain
      @frequency = options[:frequency] || 1.0
    end

    def to_resp stage_number
      "#\n" \
      "# Channel Gain\n" \
      "# ------------\n" \
      "#\n" \
      "B058F03     Stage sequence number:                  #{stage_number}\n" \
      "B058F04     Gain:                                  #{float @gain}\n" \
      "B058F05     Frequency of gain:                     #{float @frequency}\n" \
      "B058F06     Number of calibrations:                 0\n"
    end
  end

  class Decimation < Blockette
    def initialize options = {}
      @input_rate = options[:input_rate]
      @factor = options[:factor] || 1
      @offset = options[:offset] || 0
      @delay = options[:delay] || 0.0
      @correction = options[:correction] || 0.0
      raise 'Must specify input_rate.' unless @input_rate
    end

    def to_resp stage_number
      "#\n" \
      "# Decimation\n" \
      "# ----------\n" \
      "#\n" \
      "B057F03     Stage sequence number:                  #{stage_number}\n" \
      "B057F04     Input sample rate (Hz):                #{'% .4E' % @input_rate}\n" \
      "B057F05     Decimation factor:                      #{@factor}\n" \
      "B057F06     Decimation offset:                      #{@offset}\n" \
      "B057F07     Estimated delay (seconds):             #{'% .4E' % @delay}\n" \
      "B057F08     Correction applied (seconds):          #{'% .4E' % @correction}\n"
    end
  end

  Trillium = [
    Response::PolesZeros.new(
      [0, 0, -392, -1960, -1490+1470.i, -1490-1470.i],
      [-3.691e-2+3.702e-2.i, -3.691e-2-3.702e-2.i, -343, -370+467.i, -370-467.i, -836+1522.i, -836-1522.i, -4900+4700.i, -4900-4700.i, -6900, -15000],
      norm_a: 4.344928e+17,
      unit_in: 'M/S - Velocity in Meters per Second',
      unit_out: 'V - Volts'),
    Response::Gain.new(754.3)
  ]

  TrilliumOBS = [
    Response::PolesZeros.new(
      [0, 0, -434.1],
      [-0.03691+0.03712.i, -0.03691-0.03712.i, -371.2, -373.9+475.5.i, -373.9-475.5.i, -588.4+1508.i, -588.4-1508.i],
      norm_a: 8.184e11,
      unit_in: 'M/S - Velocity in Meters per Second',
      unit_out: 'V - Volts'),
    Response::Gain.new(749.1)
  ]

  def self.hti_04_pca_ulf values = {}
    r = values[:R] || 200e6 # Eingangswiderstand [Ω]
    s = values[:S] || 199.5e-6 # Sensitivität [V/Pa]
    c = values[:C] || 50e-9 # Kapazität [F]

    jtau = 2.i * Math::PI
    pole = -1 / (r * c)
    a0 = 1 / (jtau / (jtau - pole)).abs

    [
      Response::PolesZeros.new(
        [0],
        [pole],
        norm_a: a0,
        unit_in: 'Pa - Pascal',
        unit_out: 'V - Volts'),
      Response::Gain.new(s)
    ]
  end

  def self.conv a, b
    out = []
    (a.count + b.count - 1).times do |n|
      x = 0
      kmin = (n >= b.count - 1) ? n - (b.count - 1) : 0
      kmax = (n < a.count - 1) ? n : a.count - 1
      (kmin..kmax).each do |k|
        x += (a[k] || 0) * (b[n-k] || 0)
      end
      out << x
    end
    out
  end

  def self.sinc_filter rate
    decimation = 1024000 / (rate * 32)
    h = 5.times.map{[1.0 / decimation] * decimation}.reduce{|a, b| conv a, b}
    [
      Response::FIR.new(h, name: 'Sinc Filter'),
      Response::Decimation.new(input_rate: 1024000, factor: decimation, delay: (h.count - 1) / 2048000.0),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.stage1 rate
    [
      Response::FIR.new([
          3, 0, -25, 0, 150, 256, 150, 0, -25, 0, 3
        ].map{|x| (x.to_r / 512).to_f},
        name: 'FIR Stage 1'),
      Response::Decimation.new(input_rate: rate * 32, factor: 2, delay: 5.0 / (rate * 32)),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.stage2 rate
    [
      Response::FIR.new([
          -10944, 0, 103807, 0, -507903, 0, 2512192, 4194304, 2512192, 0,
          -507903, 0, 103807, 0, -10944
        ].map{|x| (x.to_r / 8388608).to_f},
        name: 'FIR Stage 2'),
      Response::Decimation.new(input_rate: rate * 16, factor: 2, delay: 7.0 / (rate * 16)),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.stage3 rate
    [
      Response::FIR.new([
          0, 0, -73, -874, -4648, -16147, -41280, -80934, -120064, -118690,
          -18203, 224751, 580196, 893263, 891396, 293598, -987253, -2635779,
          -3860322, -3572512, -822573, 4669054, 12153698, 19911100, 25779390,
          27966862, 25779390, 19911100, 12153698, 4669054, -822573, -3572512,
          -3860322, -2635779, -987253, 293598, 891396, 893263, 580196, 224751,
          -18203, -118690, -120064, -80934, -41280, -16147, -4648, -874, -73,
          0, 0
        ].map{|x| (x.to_r / 134217728).to_f},
        name: 'FIR Stage 3'),
      Response::Decimation.new(input_rate: rate * 8, factor: 4, delay: 25.0 / (rate * 8)),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.stage4 rate, options = {}
    [
      Response::FIR.new([
          -132, -432, -75, 2481, 6692, 7419, -266, -10663, -8280, 10620, 22008,
          348, -34123, -25549, 33460, 61387, -7546, -94192, -50629, 101135,
          134826, -56626, -220104, -56082, 263758, 231231, -215231, -430178,
          34715, 580424, 283878, -588382, -693209, 366118, 1084786, 132893,
          -1300087, -878642, 1162189, 1741565, -522533, -2490395, -688945,
          2811738, 2425494, -2338095, -4511116, 641555, 6661730, 2950811,
          -8538057, -10537298, 9818477, 41426374, 56835776, 41426374, 9818477,
          -10537298, -8538057, 2950811, 6661730, 641555, -4511116, -2338095,
          2425494, 2811738, -688945, -2490395, -522533, 1741565, 1162189,
          -878642, -1300087, 132893, 1084786, 366118, -693209, -588382, 283878,
          580424, 34715, -430178, -215231, 231231, 263758, -56082, -220104,
          -56626, 134826, 101135, -50629, -94192, -7546, 61387, 33460, -25549,
          -34123, 348, 22008, 10620, -8280, -10663, -266, 7419, 6692, 2481, -75,
          -432, -132
        ].map{|x| (x.to_r / 134217728).to_f},
        name: 'FIR Stage 4'),
      Response::Decimation.new(input_rate: rate * 2, factor: 2, delay: 54.0 / (rate * 2), correction: options[:last_stage] ? (31.0 / rate) : 0.0),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.filter5 rate
    [
      Response::FIR.new([
          4, -14, -46, -85, -119, -127, -91, 0, 141, 308, 455, 527, 468, 243,
          -145, -644, -1150, -1521, -1601, -1255, -400, 961, 2731, 4722, 6681,
          8335, 9442, 9830, 9442, 8335, 6681, 4722, 2731, 961, -400, -1255,
          -1601, -1521, -1150, -644, -145, 243, 468, 527, 455, 308, 141, 0, -91,
          -127, -119, -85, -46, -14, 4
        ].map{|i| (i.to_r / 65536).to_f},
        name: 'FIR Stage 5'),
      Response::Decimation.new(factor: 5, input_rate: rate * 5, delay: 27.0 / (rate * 5), correction: (11.0 / rate)),
      Response::Gain.new(1, frequency: 0)
    ]
  end

  def self.ad_conversion gain
    g = gain * 2**31
    [
      Response::Coefficients.new([], unit_in: 'V - Volts', type: 'D'),
      Response::Decimation.new(input_rate: 1024000),
      Response::Gain.new(g)
    ]
  end

  def self.mcs_datalogger rate, gain
    g = gain * 2**24 / 5.0
    [
      Response::Coefficients.new([], unit_in: 'V - Volts', type: 'D'),
      Response::Decimation.new(input_rate: rate),
      Response::Gain.new(g)
    ]
  end

  def self.print_stages f, stages
    gain = 1.0
    stages.each_with_index do |stage, i|
      s = (i + 1).to_s
      f.puts "#"
      f.puts "# Stage #{s}"
      f.puts "# ======#{'=' * s.length}"
      stage.each do |x|
        f.puts x.to_resp(i + 1)
        if x.is_a? Response::Gain
          gain *= x.gain
        end
      end
    end
    f.puts "#"
    f.puts "# Total Gain"
    f.puts "# =========="
    f.puts Response::Gain.new(gain).to_resp(0)
  end

  def self.create_resp_file name, stages, options = {}
    station = options[:station] || "ST001"
    network = options[:network] || "XX"
    location = options[:location] || "??"
    channel = options[:channel] || "BHZ"
    start_date = options[:start_date] || "2015,001,00:00:00.0000"
    end_date = options[:end_date] || "No Ending Time"
    File.open name, 'w' do |f|
      f.puts "B050F03     Station:                                #{station}"
      f.puts "B050F16     Network:                                #{network}"
      f.puts "B052F03     Location:                               #{location}"
      f.puts "B052F04     Channel:                                #{channel}"
      f.puts "B052F22     Start date:                             #{start_date}"
      f.puts "B052F23     End date:                               #{end_date}"

      print_stages f, stages
    end
  end

  # Create stages for a 6D6 datalogger.
  # You need to supply the sample rate, the input range in Volts and the stages
  # before AD conversion.
  def self.stages_6d6 rate, input_range, stages
    if rate < 250
      stages + [
        ad_conversion(1.0 / input_range),
        sinc_filter(rate * 5),
        stage1(rate * 5),
        stage2(rate * 5),
        stage3(rate * 5),
        stage4(rate * 5),
        filter5(rate),
      ]
    else
      stages + [
        ad_conversion(1.0 / input_range),
        sinc_filter(rate),
        stage1(rate),
        stage2(rate),
        stage3(rate),
        stage4(rate, last_stage: true),
      ]
    end
  end
end
