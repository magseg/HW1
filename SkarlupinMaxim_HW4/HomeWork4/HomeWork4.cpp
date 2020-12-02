#include <vector>
#include <iostream>
#include <omp.h>

using namespace std;
int main()
{
	int thread_count;
	cout << "Enter the number of teams:\n";
	cin >> thread_count;
	int m, n;
	cout << "Enter the size of the island (N x M meters):\n";
	cin >> n;
	cin >> m;
	cout << "Generate treasure:\n";
	int** arr = new int* [n];
	int rand_n = rand() % n;
	int rand_m = rand() % m;

	for (int i = 0; i < n; i++)
	{
		arr[i] = new int[m];
	}

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < m; j++)
		{
			if (i == rand_n && j == rand_m)
			{
				arr[i][j] = 1;
			}
			else
			{
				arr[i][j] = 0;
			}
			cout << arr[i][j] << "\t";
		}
		cout << endl;
	}
	bool flag = false;
	omp_set_num_threads(thread_count);
#pragma omp parallel shared(thread_count)
	{
#pragma omp for
		for (int i = 0; i < n * m; i++)
		{
			if (flag == false)
			{
#pragma omp critical
				{
					if (arr[i / m][i % m] == 0)
					{

						cout << "Thread " << omp_get_thread_num() << ". Cell " << i / m << "," << i % m << " is empty!";
						cout << endl;
					}
					else
					{
						cout << "Thread " << omp_get_thread_num() << ". Cell " << i / m << "," << i % m << " is FULL OF TRESURES!";
						cout << endl;
						flag = true;
					}
				}
			}
		}
	}
	delete[] arr;
	return 0;
}