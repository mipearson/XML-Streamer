require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe :XmlStreamer do
  
  XML = <<-EOF
    <root>
      <foo>
        <bar>
          <a>A</a>
          <b>B</b>
        </bar>
        <bar>
          <a>C</a>
          <b>D</b>
       </bar>
     </foo>
     <foo>
       <bar>
         <a>Z</a>
         <b>X</b>
         <c>Y</c>
      </bar>
    </foo>
  </root>
  EOF

  context "with no nested elements" do
    before :each do
      @streamer = XmlStreamer.new(XML, 'bar')
    end
    
    it "should render each element as a hash" do
      @streamer.to_a.should == [
        {'a' => 'A', 'b' => 'B'},
        {'a' => 'C', 'b' => 'C'},
        {'a' => 'Z', 'b' => 'X', 'c' => 'Y'}
      ]
    end
  end
end