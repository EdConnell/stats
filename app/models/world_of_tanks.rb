# encoding: utf-8

# Greg: I had to set the encoding above otherwise I
# was getting an error: (incompatible encoding regexp match
# (ASCII-8BIT regexp with UTF-8 string))

class WorldOfTanks

  def self.scrape_efficiency_rating

    doc = Nokogiri::HTML(open('http://worldoftanks.com/community/accounts/1000830827-SmokyTanker/'))
    doc_str = doc.to_s.gsub("\302\240", "")
    doc = Nokogiri::HTML(doc_str)

    session_id = doc.css(".b-data-date").children[-2].to_html.slice(/[0-9]+/).to_i #Timestamp of last website update ( should be updated after session ends )

    battles_participated = doc.css("td + td.td-number-nowidth").first.inner_text.to_i  # Testing CSS selectors

    # Greg: this was causing an error and didn't seem to be doing anything...
    # doc.css(".wrapper > .level  > .b-link").first.inner_text # Testing CSS selectors

    stats = doc.css(".t-statistic").map { |row| row.css("td").map {|cell| cell.inner_text.gsub(" ","").gsub("\n","").gsub("\303\244","a")} }
    battlestats = stats[0].each_slice(5).to_a  #Overall battle stats.  Damage, wins, detected, defense, etc.
    tankstats = stats[1].each_slice(4).to_a  #Stats for each tank.  Battles, wins, tier.
    tankstats.each do |cell| #Replaces roman numerals
      if cell[0] == "I"
        cell[0] = "1"
      elsif cell[0] == "II"
        cell[0] = "2"
      elsif cell [0] == "III"
        cell[0] = "3"
      elsif cell[0] == "IV"
        cell[0] = "4"
      elsif cell[0] == "V"
        cell[0] = "5"
      elsif cell[0] == "VI"
        cell[0] = "6"
      elsif cell[0] == "VII"
        cell[0] = "7"
      elsif cell[0] == "VIII"
        cell[0] = "8"
      elsif cell[0] == "IX"
        cell[0] = "9"
      elsif cell[0] == "X"
        cell[0] = "10"
      end
    end

    battletier = {1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>0, 9=>0, 10=>0}

    tankstats.each do |cell| #Creates hash for total battles of each tier.
      battletier[cell[0].to_i] += cell[2].to_i
    end # -> {5=>2020, 6=>1262, 1=>47, 7=>1107, 2=>393, 8=>399, 3=>725, 9=>51, 4=>992, 10=>0} Example output

    stats = { "GR"=>"", "W/B"=>"", "E/B"=>"", "WIN"=>"", "GPL"=>"", "CPT"=>"", "DMG"=>"", "DPT"=>"", "FRG"=>"", "SPT"=>"", "EXP"=>""}

    #Next function separates unneeded values from battlestats into a usable hash.
    #GR is Global rating, W/B is Win percentage, E/B is Experience/battle, Win is total number of victories.
    #GPL is total number of battles, CPT is capture points, DMG is damage caused, DPT is defense points.
    #FRG is tanks destroyed, SPT is tanks detected, EXP is total experience.

    battlestats.each do |cell|  #Populates values within the stats hash
      stats[cell[0]] = cell[3].to_i
    end
    # -> {"WIN"=>"3582", "DPT"=>"5039", "CPT"=>"16790", "GR"=>"59", "EXP"=>"3158081", "DMG"=>"3394143",
    #"GPL"=>"6996", "E/B"=>"451", "SPT"=>"10230", "FRG"=>"5306", "W/B"=>"51%"} Example output

    #Next is the Effectiveness rating calculation. "tier" = avg tier
    #Kills/Battle * (350-(tier * 20)) + ((dmg/battle) * (.2+(1.5/tier))) + (200 * (spotted/battle)) +
    #((capture points + defense points) * 150/battles)

    #These figure out basic stats as needed by the formula and to be displayed on the show page
    t = 0.00

    battletier.each do | k, v |
      t += k * v
    end # -> 36048.0

    avgtier = t / stats["GPL"]  #  36048/6996 -> 5.15265866209262

    dmgb = stats["DMG"] / stats["GPL"].to_f # -> 485.154802744425  -> sprintf("%.2f", dmgb) -> 485.15
    defb = stats["DPT"] / stats["GPL"].to_f # -> 0.720268724985706
    cptb = stats["CPT"] / stats["GPL"].to_f # -> 2.39994282447113
    frgb = stats["FRG"] / stats["GPL"].to_f # -> 0.758433390508862
    sptb = stats["SPT"] / stats["GPL"].to_f # -> 1.4622641509434

    er = frgb * (350 - (avgtier * 20)) + (dmgb * (0.2 + (1.5 / avgtier))) + (200 * sptb) + ((stats["CPT"] + stats["DPT"]) * (150 / stats["GPL"].to_f))
    # -> 1186.0425548329 which is accurate, using the old calculation method.

    return er

  end

end
