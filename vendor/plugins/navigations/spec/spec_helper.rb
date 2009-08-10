require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

unless Kernel.const_defined?(:ApplicationController)
  class ApplicationController
  end
end

unless Kernel.const_defined?(:I18n)
  class I18n
  end
end