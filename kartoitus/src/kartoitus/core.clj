(ns kartoitus.core
  (:require [marclojure.core :as marc]
            [marclojure.parser :as parser]
            [marclojure.writer :as writer]
            [clojure.data.csv :as csv]
            [clj-http.client :as client]
            [cheshire.core :refer :all]
            [clojure.java.io :as io]))

(def file "../ematerials.seq")

(def url "http://isil.kansalliskirjasto.fi/api/query?")

(defn get-isil-data [api]
  (-> api
      (client/get {:accept :json})
      :body
      parse-string
      clojure.walk/keywordize-keys
      :data))

(defn filter-isil-data [data]
  (map #(select-keys % [:isil :name]) data))

(def isil-data
  (->> url get-isil-data filter-isil-data))

(defn open-isil [isil-data isil]
  (let [item (first (filter #(= isil (:isil %)) isil-data))]
    (:name item)))

(defn load-data [file]
  (parser/load-data :aleph file))

(defn alma-talent? [record]
  (marc/record-contains-phrase? ["alma talent" "verkkokirjahylly"] record))

(defn ammattikirjasto? [record]
  (marc/record-contains-phrase? ["ammattikirjasto" "kauppakamaritieto"] record))

(defn- sort-by-value [m]
  (->> m (sort-by val) reverse))

(defn owners-of-set [batch]
  (->> batch
       (marc/field-report "LOW")
       frequencies
       sort-by-value))

(defn get-cataloger-isil [record]
  (:data (first (marc/get-subfields "040" "a" record))))

(defn get-isil-stats [batch]
  (->> batch
       (map get-cataloger-isil)
       (remove nil?)
       (map (partial open-isil isil-data))
       frequencies
       sort-by-value)

(defn write-to-file [filename data]
  (with-open [writer (io/writer filename)]
    (csv/write-csv writer data)))
