Identity::GenerateToken = Micro::Cases.flow([
  Identity::Steps::CreateToken,
  Identity::Steps::SendToken
])