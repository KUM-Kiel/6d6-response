require '../lib/response'

# Set constant values for the experiment.
rate = 250

File.read('hydrophones.csv').each_line.drop(1).each do |line|
  # Split line at commas.
  data = line.strip.split(',')
  # Extract data
  station = data[0]
  hydrophone = data[1]
  capacitance = data[2].to_f
  sensitivity = data[3].to_f
  # Convert sensitivity from dB.
  # The constant of 120 comes from the difference uPa vs Pa.
  sensitivity = 10**((sensitivity + 120) / 20.0)
  # Create resp file.
  Response.create_resp_file("resp/#{station} - #{hydrophone}.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.hti_04_pca_ulf(R: 50e6, C: capacitance, S: sensitivity),
    ]),
    station: station,
    channel: 'BDH')
end
