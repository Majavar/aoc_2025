(require '[clojure.string :as str])

(defn contains-inclusive? [[min max] n]
    (<= min n max)
)

(defn -main [& args]
    (let [
        [first-half second-half] (map str/split-lines (-> args first (or "example") slurp (str/split #"\n\n")))
        fresh-ranges (sort-by first (map #(->> (str/split % #"-") (map parse-long)) first-half))
        ingredients (map parse-long second-half)
        fresh-ingredients (filter (fn [ingredient] (some #(contains-inclusive? % ingredient) fresh-ranges)) ingredients)
    ]
        (println "Part 1:" (count fresh-ingredients))
        (println "Part 2:" (first
            (reduce (fn [[count value] [min max]] (cond
                (> min value) [(+ count (- max min) 1) max]
                (= min value) [(+ count (- max min)) max]
                (<= max value) [count value]
                :else [(+ count (- max value)) max]
            )) [1 (first (first fresh-ranges))] fresh-ranges)))))
(apply -main *command-line-args*)