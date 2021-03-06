FactoryBot.define do
  factory :job_offer do
    title { "MyString" }
    salary { "MyString" }
    salary_type { "MyString" }
    description { "MyString" }
    apply_link { "MyString" }
    company
    email { "marcin@rubyjobs.pl" }
    remote { "1" }
    city_names { "Warszawa, Białystok" }
    token { "123" }
    state { "created" }
  end
end
