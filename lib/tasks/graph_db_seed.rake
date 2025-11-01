namespace :graph_db_seed do
  desc "Seed question bank into Neo4j with embedded options"
  task question_bank_seed: :environment do
    session = Neo4jDriver.session

    session.write_transaction do |tx|
      # Topics
      tx.run("CREATE (t:Topic {name: 'Math'})")
      tx.run("CREATE (t:Topic {name: 'Science'})")
      tx.run("CREATE (t:Topic {name: 'Blood Relations'})")

      # Math Question
      tx.run(%{
        MATCH (t:Topic {name: 'Math'})
        CREATE (q:Question {
          text: 'What is 2+2?',
          options: ['3', '4'],
          correct_option_id: 1
        })
        CREATE (tag:Tag {name: 'Addition'})
        MERGE (t)-[:HAS_QUESTION]->(q)
        MERGE (q)-[:TAGGED_WITH]->(tag)
      })

      # Blood Relation Question 1
      tx.run(%{
        MATCH (t:Topic {name: 'Blood Relations'})
        CREATE (q:Question {
          text: 'Pointing to a man, Ravi said, “He is my father’s only son’s wife’s father.” Who is the man to Ravi?',
          options: ['Maternal Grandfather', 'Father-in-law', 'Uncle', 'Father'],
          correct_option_id: 1
        })
        CREATE (tag:Tag {name: 'Family Tree'})
        MERGE (t)-[:HAS_QUESTION]->(q)
        MERGE (q)-[:TAGGED_WITH]->(tag)
      })

      # Blood Relation Question 2
      tx.run(%{
        MATCH (t:Topic {name: 'Blood Relations'})
        CREATE (q:Question {
          text: 'Pointing to a lady, John said, “She is the daughter of my mother’s only son.” How is the lady related to John?',
          options: ['Daughter', 'Sister', 'Niece', 'Cousin'],
          correct_option_id: 0
        })
        CREATE (tag:Tag {name: 'Blood Relation - Direct'})
        MERGE (t)-[:HAS_QUESTION]->(q)
        MERGE (q)-[:TAGGED_WITH]->(tag)
      })

      # Blood Relation Question 3
      tx.run(%{
        MATCH (t:Topic {name: 'Blood Relations'})
        CREATE (q:Question {
          text: 'A is the father of B, but B is not the son of A. How is B related to A?',
          options: ['Daughter', 'Son', 'Sister', 'Mother'],
          correct_option_id: 0
        })
        CREATE (tag:Tag {name: 'Blood Relation - Trick Question'})
        MERGE (t)-[:HAS_QUESTION]->(q)
        MERGE (q)-[:TAGGED_WITH]->(tag)
      })

      # Blood Relation Question 4
      tx.run(%{
        MATCH (t:Topic {name: 'Blood Relations'})
        CREATE (q:Question {
          text: 'Ramesh is the son of Suresh. Ramesh’s uncle is the father of Anil. How is Anil related to Ramesh?',
          options: ['Cousin', 'Brother', 'Uncle', 'Nephew'],
          correct_option_id: 0
        })
        CREATE (tag:Tag {name: 'Family Tree'})
        MERGE (t)-[:HAS_QUESTION]->(q)
        MERGE (q)-[:TAGGED_WITH]->(tag)
      })
    end

    puts "✅ Question bank seeded successfully into Neo4j"
  end
end
