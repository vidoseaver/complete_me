require '../lib/complete_me'
require '../lib/node'

complete_me = CompleteMe.new
# @complete_me.populate_from_txt("mock_dictionary.txt")
# @complete_me.populate_from_csv("short_addresses.csv")
file = File.read("/usr/share/dict/words")
complete_me.populate(file)

Shoes.app do
    stack(margin: 8) do
      flow do
        @suggest_phrase_line = edit_line
        @selected_word = edit_line
        end
        #results = complete_me.suggest("aaron")
      flow do
        button("Suggest") do
          results = complete_me.suggest(@suggest_phrase_line.text).join(", ")
          # para results
          @test.text = results
        end

        button("Select") do
        stack do
        complete_me.select(@suggest_phrase_line.text, @selected_word.text)
        results = complete_me.suggest(@suggest_phrase_line.text)
        para results.join(", ")
      end
        end
      end
    end

    @test = textblock
end
