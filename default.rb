require './lib/response'

[50, 100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D6-Trillium-#{rate}sps.resp",
    Response.stages_6d6(rate, 20 * Math.sqrt(2), [
      Response::TrilliumCompact120,
    ]))
end

[50, 100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D6-HTI-04-PCA-ULF-INA3M-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.hti_04_pca_ulf(R: 3e6),
    ]),
    channel: 'BDH')
end

[50, 100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D6-HTI-04-PCA-ULF-INA200M-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.hti_04_pca_ulf(R: 200e6),
    ]),
    channel: 'BDH')
end

[50, 100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D6-HTI-04-PCA-ULF-HELGA-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.hti_04_pca_ulf(R: 50e6),
    ]),
    channel: 'BDH')
end

[100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D7-Trillium-#{rate}sps.resp",
    Response.stages_6d6(rate, 20 * Math.sqrt(2), [
      Response::TrilliumCompact120,
    ]))
end

[100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D7-HTI-04-PCA-ULF-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.hti_04_pca_ulf(R: 200e6),
    ]),
    channel: 'BDH')
end

[100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D7-Geophone-4.5Hz-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      [
        Response::PolesZeros.new(
          [0, 0],
          [-19.7810-20.2027.i, -19.7810+20.2027.i],
          norm_a: 1,
          norm_f: 45,
          unit_in: 'M/S - Velocity in Meters per Second',
          unit_out: 'V - Volts'),
        Response::Gain.new(1.76, frequency: 45)
      ]
    ]),
    channel: 'SHZ')
end

[100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D7-Geophone-DTCC-5Hz-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      [
        Response::PolesZeros.new(
          [0, 0],
          [-22.2111-22.2178.i, -22.2111+22.2178.i],
          norm_a: 1,
          norm_f: 50,
          unit_in: 'M/S - Velocity in Meters per Second',
          unit_out: 'V - Volts'),
        Response::Gain.new(1.76, frequency: 50)
      ]
    ]),
    channel: 'SHZ')
end

[100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D7-Geophone-ALF-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      [
        Response::PolesZeros.new(
          [0, 0],
          [-8.0-2.6.i, -8.0+2.6.i],
          norm_a: 1,
          norm_f: 50,
          unit_in: 'M/S - Velocity in Meters per Second',
          unit_out: 'V - Volts'),
        Response::Gain.new(4.76, frequency: 50)
      ]
    ]),
    channel: 'SHZ')
end
