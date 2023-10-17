(ns python
  (:require
   [libpython-clj2.python :as py]
   [libpython-clj2.require :refer [require-python]]))

(require-python
 '[numpy :as np]
 '[scipy.spatial.distance :as spatial.distance]
 '[sentence_transformers :refer [SentenceTransformer]])

(def model
  (SentenceTransformer "sentence-transformers/all-MiniLM-L6-v2"))

(defn encode
  [strings]
  (zipmap strings (py/py. model encode strings)))

(comment)

(comment
  (encode ["A" "B" "C"])
  (spatial.distance/euclidean [1 0 0] [0 1 0])

  (let [ndarray (first (py/py. model encode ["a"]))]
    (py/py. ndarray tolist)))
