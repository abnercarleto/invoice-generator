module Financial
  module Steps
    class ExportInvoice < Micro::Case
      attributes :invoice, :exporter

      def call!
        Success result: { exported_str: exporter.call(invoice: invoice), type: exporter.type }
      end
    end
  end
end