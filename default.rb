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

[50, 100, 250, 500, 1000, 2000, 4000].each do |rate|
  Response.create_resp_file("resp/6D6-Geophone_4point5_Hz-#{rate}sps.resp",
    Response.stages_6d6(rate, 0.625, [
      Response.geophone_4point5_Hz(R: 3e6),
    ]),
    channel: 'SHZ')
end
