# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Muúltiplos boletos' do # :nodoc:[all]
  before do
    @valid_attributes = {
      valor: 0.0,
      cedente: 'Kivanio Barbosa',
      documento_cedente: '12345678912',
      sacado: 'Claudio Pozzebom',
      documento_sacado: '12345678900',
      agencia: '4042',
      conta_corrente: '61900',
      convenio: 12_387_989,
      nosso_numero: '777700168'
    }
  end

  it 'imprimir múltiplos boleto em lote' do
    boleto_1 = Brcobranca::Boleto::BancoBrasil.new(@valid_attributes)
    boleto_2 = Brcobranca::Boleto::Bradesco.new(@valid_attributes)
    boleto_3 = Brcobranca::Boleto::BancoBrasil.new(@valid_attributes)

    boletos = [boleto_1, boleto_2, boleto_3]

    %w[pdf jpg tif png].each do |format|
      file_body = Brcobranca::Boleto::Base.lote(boletos, formato: format.to_s.to_sym)
      tmp_file = Tempfile.new(['foobar.', format])
      tmp_file.puts file_body
      tmp_file.close
      expect(File).to exist(tmp_file.path)
      expect(File.stat(tmp_file.path)).not_to be_zero
      expect(File.delete(tmp_file.path)).to be(1)
      expect(File).not_to exist(tmp_file.path)
    end
  end
end
