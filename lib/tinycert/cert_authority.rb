class Tinycert::CertAuthority
  attr_reader :id, :name

  def initialize tinycert, results
    @tinycert = tinycert
    parse_results results
  end

  def parse_results results
    @id = results['id']
    @name = results['name']
  end

  def certs
    Tinycert::Certs.new(@tinycert, self)
  end

  def details
  end

  def delete
  end
end
