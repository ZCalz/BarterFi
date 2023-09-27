import React, { useState } from 'react';

interface FormValues {
  name: string;
  email: string;
  address: string;
  idNumber: string;
}

const RegisterForm: React.FC = () => {
  const [formValues, setFormValues] = useState<FormValues>({
    name: '',
    email: '',
    address: '',
    idNumber: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormValues(prevState => ({ ...prevState, [name]: value }));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    // Handle form submission here
  };

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <label className="text-gray-700 font-semibold" htmlFor="name">
        Name
      </label>
      <input
        className="border border-gray-300 rounded-lg py-2 px-3"
        type="text"
        name="name"
        id="name"
        value={formValues.name}
        onChange={handleChange}
        required
      />
      <label className="text-gray-700 font-semibold" htmlFor="email">
        Email
      </label>
      <input
        className="border border-gray-300 rounded-lg py-2 px-3"
        type="email"
        name="email"
        id="email"
        value={formValues.email}
        onChange={handleChange}
        required
      />
      <label className="text-gray-700 font-semibold" htmlFor="address">
        Address
      </label>
      <input
        className="border border-gray-300 rounded-lg py-2 px-3"
        type="text"
        name="address"
        id="address"
        value={formValues.address}
        onChange={handleChange}
        required
      />
      <label className="text-gray-700 font-semibold" htmlFor="idNumber">
        ID Number
      </label>
      <input
        className="border border-gray-300 rounded-lg py-2 px-3"
        type="text"
        name="idNumber"
        id="idNumber"
        value={formValues.idNumber}
        onChange={handleChange}
        required
      />
      <button
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        type="submit"
      >
        Send
      </button>
    </form>
  );
};

export default RegisterForm;
